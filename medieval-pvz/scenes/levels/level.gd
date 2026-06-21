extends Node2D

@onready var gold_label: Label = $gold_label
@onready var grid: Node2D = $Grid
@onready var castle: Node2D = $Castle
@onready var unit_selector: Control = $UnitSelector
var selected_unit_data: UnitData = null

func _ready():
	print("LEVEL READY - this script is running")
	GoldManager.gold_changed.connect(_on_gold_changed)
	gold_label.text = "Gold: " + str(GoldManager.gold)
	grid.cell_selected.connect(_on_cell_selected)
	WaveManager.initialize(grid, self)
	WaveManager.endless_mode = true
	WaveManager.start_wave(WaveManager.generate_wave(5))
	castle.castle_reached.connect(_on_castle_reached)
	unit_selector.unit_selected.connect(_on_unit_selected)
	selected_unit_data = unit_selector.selected_data

func _on_unit_selected(data: UnitData) -> void:
	selected_unit_data = data
	print("Selected Unit changed to: ", data)

func _on_castle_reached() -> void:
	print("GAME OVER")
	get_tree().paused = true

func _on_gold_changed(new_amount: int) -> void:
	gold_label.text = "Gold: " + str(new_amount)

func _on_cell_selected(cell: Vector2i) -> void:
	#<LK>: There's already a unit in that cell!
	if grid.is_cell_occupied_by_unit(cell):
		return
	if GoldManager.spend_gold(selected_unit_data.cost):
		place_unit(cell)

func place_unit(cell: Vector2i) -> void:
	var unit_scene: PackedScene = load(selected_unit_data.scene_path)
	var unit = unit_scene.instantiate()
	unit.position = grid.grid_to_world(cell)
	unit.grid_cell = cell
	unit.grid_ref = grid
	unit.data = selected_unit_data
	add_child(unit)
	grid.occupy_unit_cell(cell, unit)
