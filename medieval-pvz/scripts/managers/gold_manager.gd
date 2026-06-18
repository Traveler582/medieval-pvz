extends Node

signal gold_changed(new_amount: int)

var gold: int = 100
var passive_income: int = 10
var income_interval: float = 5.0
var _timer: float = 0.0

func _process(delta):
	_timer += delta
	if _timer >= income_interval:
		_timer = 0.0
		add_gold(passive_income)

func add_gold(amount: int) -> void:
	gold += amount
	emit_signal("gold_changed", gold)

func spend_gold(amount: int) -> bool:
	if amount > gold:
		return false
	gold -= amount
	emit_signal("gold_changed", gold)
	return true
