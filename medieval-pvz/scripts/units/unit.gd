extends Node2D
class_name Unit

@export var data: UnitData
@onready var health_bar: ProgressBar = $ProgressBar
@onready var sprite: AnimatedSprite2D = $Sprite

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
	sprite.play("idle")

func _process(delta):
	if is_dead or not grid_ref or is_attacking: 
		return
	
	var same_cell_enemy = grid_ref.get_enemy_in_cell(grid_cell)
	if same_cell_enemy and is_instance_valid(same_cell_enemy):
		attack_timer += delta
		if attack_timer >= 1.0 / data.attack_speed:
			attack_timer = 0.0
			start_attack(same_cell_enemy)
		return
	
	var target_cell = grid_cell + Vector2i(1, 0)
	current_target = grid_ref.get_enemy_in_cell(target_cell)
	
	if current_target:
		attack_timer += delta
		if attack_timer >= 1.0 / data.attack_speed:
			attack_timer = 0.0
			start_attack(current_target)
	else:
		if sprite.animation != "idle":
			sprite.play("idle")

func start_attack(target: Node) -> void:
	is_attacking = true
	var impact_frame = play_random_attack()
	var damage_applied = false
	while sprite.is_playing():
		if sprite.frame >= impact_frame and not damage_applied:
			damage_applied = true
			if not is_dead and is_instance_valid(target) and not target.is_dead:
				target.take_damage(data.damage)
		await get_tree().process_frame
	is_attacking = false

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
	print("Unit took damage: ", amount, " at time: ", Time.get_ticks_msec())
	current_health -= amount
	health_bar.value = current_health
	if current_health <= 0:
		die()
	else:
		sprite.play("hurt")
		await sprite.animation_finished
		if not is_dead:
			sprite.play("idle")

func die() -> void:
	is_dead = true
	attack_timer = 0.0
	sprite.play("death")
	if grid_ref and grid_ref.is_valid_cell(grid_cell):
		grid_ref.free_unit_cell(grid_cell)
	await sprite.animation_finished
	queue_free()
