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
		if current_target and is_instance_valid(current_target):
			attack_timer += delta
			if attack_timer >= 1.0:
				attack_timer = 0.0
				current_target.take_damage(data.damage)
		else:
			is_fighting = false
			current_target = null
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

func _on_area_entered(other_area: Area2D) -> void:
	print("Area entered: ", other_area)
	var parent = other_area.get_parent()
	print("Parent: ", parent, " | Is Unit: ", parent is Unit)
	if parent is Unit:
		is_fighting = true
		current_target = parent

func _on_area_exited(other_area: Area2D) -> void:
	print("Area exited: ", other_area)
	var parent = other_area.get_parent()
	if parent == current_target:
		is_fighting = false
		current_target = null
func take_damage(amount: int) -> void:
	current_health -= amount
	if current_health <= 0:
		die()

func die() -> void:
	if grid_ref and grid_ref.is_valid_cell(current_cell):
		grid_ref.occupied_cells.erase(current_cell)
	queue_free()
