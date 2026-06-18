extends Node2D

@onready var gold_label: Label = $gold_label

func _ready():
	GoldManager.gold_changed.connect(_on_gold_changed)
	gold_label.text = "Gold: " + str(GoldManager.gold)

func _on_gold_changed(new_amount: int) -> void:
	gold_label.text = "Gold: " + str(new_amount)
