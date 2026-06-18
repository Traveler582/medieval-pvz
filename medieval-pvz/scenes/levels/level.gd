extends Node2D

@onready var gold_label: Label = $gold_label
@onready var grid: Node2D = $Grid
# TODO <LK>: Change this to have a different value based on the unit the player has selected
#      at the current moment
var selected_unit_data: UnitData = preload("res://resources/units/knight.tres")

func _ready():
	GoldManager.gold_changed.connect(_on_gold_changed)
	gold_label.text = "Gold: " + str(GoldManager.gold)
	grid.cell_selected.connect(_on_cell_selected)

func _on_gold_changed(new_amount: int) -> void:
	gold_label.text = "Gold: " + str(new_amount)

func _on_cell_selected(cell: Vector2i) -> void:
	#<LK>: There's already a unit in that cell!
	if grid.is_cell_occupied(cell):
		return
	if GoldManager.spend_gold(selected_unit_data.cost):
		place_unit(cell)

func place_unit(cell: Vector2i) -> void:
	var unit_scene: PackedScene = preload("res://scenes/units/knight.tscn")
	var unit = unit_scene.instantiate()
	unit.position = grid.grid_to_world(cell)
	add_child(unit)
	grid.occupy_cell(cell, unit)
