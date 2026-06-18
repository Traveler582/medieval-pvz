extends Node2D
class_name EnemyBase

@export var data: EnemyData

var current_health: int
var lane: int = 0

func _ready():
	if data:
		current_health = data.health

func _process(delta):
	position.x -= data.speed * delta

func take_damage(amount: int) -> void:
	current_health -= amount
	if current_health <= 0:
		die()

func die() -> void:
	queue_free()
