extends Node

class_name HealSystem

func _ready():
	EventsGlobal.heal.connect(_on_heal)

func _on_heal(target, amount):
	# Логика лечения цели
	target.apply_heal(amount)

