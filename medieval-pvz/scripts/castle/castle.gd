extends Node2D

signal castle_reached

@onready var area: Area2D = $Area2D

func _ready():
	area.area_entered.connect(_on_area_entered)

func _on_area_entered(other_area: Area2D) -> void:
	var parent = other_area.get_parent()
	if parent is EnemyBase:
		castle_reached.emit()
		parent.reach_castle()
