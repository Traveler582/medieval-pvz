extends Node2D
class_name EnemyBase

@export var data: EnemyData
@onready var area: Area2D = $Area2D

var current_health: int
var lane: int = 0
var grid_ref: Node
var current_cell: Vector2i = Vector2i(-1, -1)

var is_fighting: bool = false
var current_target: Node = null
var attack_timer: float = 0.0

func _ready():
	if data:
		current_health = data.health
	area.area_entered.connect(_on_area_entered)
	area.area_exited.connect(_on_area_exited)

func _process(delta):
	if is_fighting:
		overlapping_units = overlapping_units.filter(func(u): return is_instance_valid(u))
		if overlapping_units.size() > 0:
			var target = overlapping_units[0]
			for u in overlapping_units:
				if u.position.x > target.position.x:
					target = u
			attack_timer += delta
			if attack_timer >= 1.0:
				attack_timer = 0.0
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
			grid_ref.occupied_cells.erase(current_cell)
		current_cell = new_cell
		if grid_ref.is_valid_cell(new_cell):
			grid_ref.occupy_cell(new_cell, self)

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
	if current_health <= 0:
		die()

func die() -> void:
	if grid_ref and grid_ref.is_valid_cell(current_cell):
		grid_ref.occupied_cells.erase(current_cell)
	queue_free()
