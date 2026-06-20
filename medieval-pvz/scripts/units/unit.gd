extends Node2D
class_name Unit

@export var data: UnitData

@onready var health_bar: ProgressBar = $ProgressBar

var current_health: int
var grid_cell: Vector2i
var grid_ref: Node
var attack_timer: float = 0.0
var current_target: Node = null

func _ready():
	if data:
		current_health = data.health
		health_bar.max_value = data.health
		health_bar.value = current_health

func _process(delta):
	if not grid_ref:
		return
	
	var target_cell = grid_cell + Vector2i(1, 0)
	current_target = grid_ref.get_enemy_in_cell(target_cell)
	
	if current_target:
		attack_timer += delta
		if attack_timer >= 1.0 / data.attack_speed:
			attack_timer = 0.0
			current_target.take_damage(data.damage)

func take_damage(amount: int) -> void:
	current_health -= amount
	health_bar.value = current_health
	if current_health <= 0:
		die()

func die() -> void:
	if grid_ref and grid_ref.is_valid_cell(grid_cell):
		grid_ref.occupied_cells.erase(grid_cell)
	queue_free()
