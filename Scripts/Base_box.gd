extends Area3D

class_name Base_box

@export var value = 0

func _on_body_entered(body):
	
	if body is Object:  
		print("Объект ", body, " вошел в зону коллизии")
		EventsGlobal.emit_signal("damage", body, value)
