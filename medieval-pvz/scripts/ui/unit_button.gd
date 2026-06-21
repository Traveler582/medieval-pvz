extends Button

signal unit_selected(data: UnitData)

@export var unit_data: UnitData

@onready var cost_label: Label = $Label
@onready var color_rect: ColorRect = $ColorRect

func _ready():
	cost_label.text = str(unit_data.cost)
	pressed.connect(_on_pressed)
	GoldManager.gold_changed.connect(_on_gold_changed)
	_update_affordability(GoldManager.gold)

func _on_pressed():
	print("Button pressed: ", unit_data.unit_name)
	unit_selected.emit(unit_data)

func _on_gold_changed(new_amount: int) -> void:
	_update_affordability(new_amount)

func _update_affordability(gold: int) -> void:
	if gold < unit_data.cost:
		cost_label.modulate = Color.RED
	else:
		cost_label.modulate = Color.WHITE

func set_selected(is_selected: bool) -> void:
	if is_selected:
		modulate = Color(1.0, 1.0, 0.6)
	else:
		modulate = Color.WHITE
