extends Node3D

@export var sens = 0.5
var mouse_hor = 0
var mouse_ver = 0
var cam_v_max = 45
var cam_v_min = -25
var start_pos = position
@onready var player = $".."
@onready var camera_3d = $Camera3D

func _ready():
	mouse_hor = player.rotation_degrees.y


func _input(event):
	if is_multiplayer_authority():  # Обрабатываем ввод только если это локальный игрок
		if event is InputEventMouseMotion and Input.get_mouse_mode() != Input.MOUSE_MODE_VISIBLE:
			mouse_hor += -event.relative.x * (sens / 10)
			mouse_ver += event.relative.y * (sens / 10)

func _process(_delta):
	if is_multiplayer_authority():
		mouse_ver = clamp(mouse_ver, cam_v_min, cam_v_max)
		rotation_degrees.x = mouse_ver
		rotation_degrees.y = mouse_hor
		position = start_pos + get_parent().position
