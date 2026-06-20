extends Node2D
class_name EnemyBase

@export var data: EnemyData
@onready var area: Area2D = $Area2D
@onready var health_bar: ProgressBar = $ProgressBar
var current_health: int
var lane: int = 0
var grid_ref: Node
var current_cell: Vector2i = Vector2i(-1, -1)

var is_fighting: bool = false
var current_target: Node = null
var same_cell_attack_timer: float = 0.0
var adjacent_attack_timer: float = 0.0

func _ready():
	if data:
		current_health = data.health
		health_bar.max_value = data.health
		health_bar.value = current_health
	area.area_entered.connect(_on_area_entered)
	area.area_exited.connect(_on_area_exited)

func _process(delta):
	if not grid_ref:
		position.x -= data.speed * delta
		return
	
	var same_cell_unit = grid_ref.get_unit_in_cell(current_cell)
	if same_cell_unit and is_instance_valid(same_cell_unit):
		same_cell_attack_timer += delta
		if same_cell_attack_timer >= 1.0:
			same_cell_attack_timer = 0.0
			same_cell_unit.take_damage(data.damage)
		return
	
	if is_fighting:
		overlapping_units = overlapping_units.filter(func(u): return is_instance_valid(u))
		if overlapping_units.size() > 0:
			var target = overlapping_units[0]
			for u in overlapping_units:
				if u.position.x > target.position.x:
					target = u
			adjacent_attack_timer += delta
			if adjacent_attack_timer >= 1.0:
				adjacent_attack_timer = 0.0
				target.take_damage(data.damage)
		else:
			is_fighting = false
	else:
		position.x -= data.speed * delta
		update_grid_cell()

func update_grid_cell() -> void:
	if not grid_ref:
		return
	var new_cell = grid_ref.world_to_grid(position)
	if new_cell != current_cell:
		if grid_ref.is_valid_cell(current_cell):
			grid_ref.free_enemy_cell(current_cell)
		current_cell = new_cell
		if grid_ref.is_valid_cell(new_cell):
			grid_ref.occupy_enemy_cell(new_cell, self)

var overlapping_units: Array = []
func _on_area_entered(other_area: Area2D) -> void:
	var parent = other_area.get_parent()
	if parent is Unit:
		overlapping_units.append(parent)
		is_fighting = true

func _on_area_exited(other_area: Area2D) -> void:
	var parent = other_area.get_parent()
	if parent in overlapping_units:
		overlapping_units.erase(parent)
	if overlapping_units.is_empty():
		is_fighting = false

func take_damage(amount: int) -> void:
	current_health -= amount
	health_bar.value = current_health
	if current_health <= 0:
		die()

func die() -> void:
	if grid_ref and grid_ref.is_valid_cell(current_cell):
		grid_ref.free_enemy_cell(current_cell)
	queue_free()
