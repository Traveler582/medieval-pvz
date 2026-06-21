extends Control

signal unit_selected(data: UnitData)

@onready var button_container: HBoxContainer = $HBoxContainer

var buttons: Array = []
var selected_data: UnitData = null

func _ready():
	print("UnitSelector ready, button count: ", button_container.get_children().size())
	for child in button_container.get_children():
		buttons.append(child)
		child.unit_selected.connect(_on_unit_selected)
	
	if buttons.size() > 0:
		print("Auto-selecting first button")
		_on_unit_selected(buttons[0].unit_data)

func _on_unit_selected(data: UnitData) -> void:
	selected_data = data
	unit_selected.emit(data)
	for b in buttons:
		b.set_selected(b.unit_data == data)
