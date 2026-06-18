extends Node2D
class_name Unit

@export var data: UnitData

@onready var health_bar: ProgressBar = $ProgressBar

var current_health: int

func _ready():
	if data:
		current_health = data.health
		health_bar.max_value = data.health
		health_bar.value = current_health

func take_damage(amount: int) -> void:
	current_health -= amount
	health_bar.value = current_health
	if current_health <= 0:
		die()

func die() -> void:
	queue_free()
