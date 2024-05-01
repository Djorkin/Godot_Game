extends Node

class_name DamageSystem


func _ready():
	EventsGlobal.damage.connect(_on_damage)

func _on_damage(target, amount):
	# Логика нанесения урона цели
	target.apply_damage(amount)

