extends Control


var FPS : int
@onready var health_bar = $Health_bar
@onready var hp_value = $Health_bar/HP_Value
@onready var fps = $FPS
@onready var player = $".."


func update_UI(HP, max_HP):
	health_bar.max_value = max_HP
	health_bar.value = HP
	hp_value.text = str(HP) + "/" + str(max_HP)



func _process(delta):
	FPS = 1/delta
	fps.text = "FPS " + str(FPS)
