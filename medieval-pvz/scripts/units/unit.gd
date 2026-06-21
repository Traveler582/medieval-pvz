extends Node2D
class_name Unit

@export var data: UnitData
@onready var health_bar: ProgressBar = $ProgressBar
@onready var sprite: AnimatedSprite2D = get_node_or_null("Sprite")

var current_health: int
var grid_cell: Vector2i
var grid_ref: Node
var attack_timer: float = 0.0
var current_target: Node = null
var is_dead: bool = false
var is_attacking: bool = false

func _ready():
	if data:
		current_health = data.health
		health_bar.max_value = data.health
		health_bar.value = current_health
	if sprite:
		sprite.play("idle")

func _process(delta):
	if is_dead or not grid_ref: 
		return
	
	var same_cell_enemy = grid_ref.get_enemy_in_cell(grid_cell)
	if same_cell_enemy and is_instance_valid(same_cell_enemy):
		attack_timer += delta
		if attack_timer >= 1.0 / data.attack_speed:
			attack_timer = 0.0
			start_attack(same_cell_enemy)
		return
	
	current_target = find_target_in_range()
	
	if current_target:
		attack_timer += delta
		if attack_timer >= 1.0 / data.attack_speed:
			attack_timer = 0.0
			start_attack(current_target)
	else:
		if sprite and sprite.animation != "idle":
			sprite.play("idle")

func find_target_in_range() -> Node:
	for i in range(1, data.attack_range + 1):
		var check_cell = grid_cell + Vector2i(i, 0)
		var enemy = grid_ref.get_enemy_in_cell(check_cell)
		if enemy and is_instance_valid(enemy):
			return enemy
	return null

func start_attack(target: Node) -> void:
	is_attacking = true
	
	if not sprite:
		# No sprite yet (placeholder unit) — resolve attack instantly
		if data.projectile_scene:
			fire_projectile(target)
		else:
			if not is_dead and is_instance_valid(target) and not target.is_dead:
				target.take_damage(data.damage)
		is_attacking = false
		return
	
	if data.projectile_scene:
		var impact_frame = play_random_attack()
		var fired = false
		while sprite.is_playing():
			if sprite.frame >= impact_frame and not fired:
				fired = true
				fire_projectile(target)
			await get_tree().process_frame
		is_attacking = false
	else:
		var impact_frame = play_random_attack()
		var damage_applied = false
		while sprite.is_playing():
			if sprite.frame >= impact_frame and not damage_applied:
				damage_applied = true
				if not is_dead and is_instance_valid(target) and not target.is_dead:
					target.take_damage(data.damage)
			await get_tree().process_frame
		is_attacking = false

func fire_projectile(target: Node) -> void:
	if is_dead or not is_instance_valid(target) or target.is_dead:
		return
	var arrow_scene = data.projectile_scene
	var arrow = arrow_scene.instantiate()
	arrow.target = target
	arrow.damage = data.damage
	arrow.global_position = global_position
	get_tree().current_scene.add_child(arrow)

func play_random_attack() -> int:
	var attack_animations = {
		"attack1": 5,
		"attack2": 4
	}
	var keys = attack_animations.keys()
	var chosen = keys[randi() % keys.size()]
	sprite.play(chosen)
	return attack_animations[chosen]

func take_damage(amount: int) -> void:
	current_health -= amount
	health_bar.value = current_health
	if current_health <= 0:
		die()
	else:
		if sprite:
			sprite.play("hurt")
			await sprite.animation_finished
			if not is_dead:
				sprite.play("idle")

func die() -> void:
	is_dead = true
	attack_timer = 0.0
	if grid_ref and grid_ref.is_valid_cell(grid_cell):
		grid_ref.free_unit_cell(grid_cell)
	if sprite:
		sprite.play("death")
		await sprite.animation_finished
	queue_free()
