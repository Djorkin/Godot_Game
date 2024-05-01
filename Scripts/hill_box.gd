extends Base_box

class_name hill_box


func _on_body_entered(body):
	
	if body is Object:  
		var collidingObject = body  
		print("Объект", collidingObject, " вошел в зону коллизии")
		EventsGlobal.emit_signal("heal", body, value)
