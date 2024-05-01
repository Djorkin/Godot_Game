extends Button

@onready var control = $"../.."


func _on_pressed():
	control.hide()
