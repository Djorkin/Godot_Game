extends CharacterBody3D

class_name Player


@export var inventory_ui : PackedScene
@export var player_ui : PackedScene
@export var HP = 1000
@export var max_HP = 1000
@export var acceleration = 20
@export var idle = 0
@export var walk = 5
@export var run = 10
@export var jump_forse = 10
@export var gravity = 20
@onready var camera_control = $Camera_control
@onready var mesh = $Mesh
@onready var player = $"."
@onready var label_3d = $Label3D
@onready var animation_tree = $AnimationTree

var player_ui_instance
var inventory_ui_instance
var is_dead : bool = false
var inventory = Inventory.new()
var moved_vector = Vector3()
var speed = 0
const RAD_TO_DEG = 180.0 / PI
const DEG_TO_RAD = PI / 180.0


func _ready():
	get_instance_ui()
	print ("Инвентарь " + str(inventory.get_items()))
	set_nickname()
	update_hp_bar()
	setup_camera()
	inventory.add_item(inventory.POISON_HEAL, 12)
	inventory.add_item(inventory.POISON_HEAL, 12)
	inventory.add_item(inventory.POISON_PAIN, 23)

func _physics_process(delta):
	if is_multiplayer_authority():
		input_player(delta)

func input_player(delta):

	_set_move_vector()
	if is_movement_input_pressed() and moved_vector:
		_set_rotate(delta)
		if Input.is_action_pressed("Shift") and is_on_floor():
			_run()
		else: _walk()

	if !is_movement_input_pressed() or moved_vector == Vector3.ZERO:
		_idle()

	if Input.is_action_just_pressed("jump"):
		_jump(delta)

	_fall(delta)
	_move(delta)


	if Input.is_action_just_pressed("Inventory"):
		inv_vis()

func pick_up_item(picked_item):
	inventory.add_item(picked_item)
	print("Подобран предмет: ", picked_item)

func is_movement_input_pressed() -> bool:
	return Input.is_action_pressed("forward") or Input.is_action_pressed("back") or Input.is_action_pressed("left") or Input.is_action_pressed("right")

# Функция для получения вектора движения
func _set_move_vector():
	moved_vector.x = Input.get_action_strength("right")-Input.get_action_strength("left")
	moved_vector.y = 0
	moved_vector.z = Input.get_action_strength("back")-Input.get_action_strength("forward")
	moved_vector = moved_vector.normalized()
	return moved_vector

# Функция для плавного поворота персонажа
func _set_rotate(delta: float):
	rotation_degrees.y = camera_control.rotation_degrees.y
	var angle_rad = atan2(moved_vector.x, -moved_vector.z)
	var angle = angle_rad * RAD_TO_DEG
	
	# Вычисляем минимальный угол между текущим и целевым углом
	var shortest = shortest_angle(mesh.rotation_degrees.y, -angle)
	# Плавно поворачиваем объект к целевому углу
	mesh.rotation_degrees.y = lerp(mesh.rotation_degrees.y, mesh.rotation_degrees.y + shortest, delta * acceleration)

# Функция для вычисления минимального угла между двумя углами нужна для поворота
func shortest_angle(from_angle, to_angle):
	var from_angle_int = int(from_angle)  # Приведение к целочисленному типу данных
	var to_angle_int = int(to_angle)  # Приведение к целочисленному типу данных
	var difference = (to_angle_int - from_angle_int) % 360
	return (2 * difference) % 360 - difference

func _idle():
	animation_tree.set("parameters/Transition/transition_request", "Idle")
	speed = idle

func _walk():
	animation_tree.set("parameters/Transition/transition_request", "Walk")
	speed = walk

func _run():
	animation_tree.set("parameters/Transition/transition_request", "Run")
	speed = run

func _jump(delta : float):
	if is_on_floor():
		animation_tree.set("parameters/Transition/transition_request", "Jump")
		velocity.y = jump_forse * (1/delta/60) * 6 

func _fall(delta : float):
	if !is_on_floor():
		animation_tree.set("parameters/Transition/transition_request", "Jump")
		velocity.y -= gravity * delta

func _move(delta : float):
	if moved_vector:
		player.translate(-moved_vector * delta * speed)
	player.move_and_slide()
	if is_on_floor():
		velocity = Vector3.ZERO

func apply_damage(damage : float):
	if damage < 0:
		apply_heal(-damage)
	else:
		HP -= damage
		print("Получен урон: ",damage, "  ХП = ", HP)
	update_hp_bar()
	if HP <= 0:
		dead()

func apply_heal(heal : float):
	HP = clamp(HP + heal, 0, max_HP)
	print("Получен хил: ",heal, "  ХП = ", HP)
	update_hp_bar()

func update_hp_bar():
	HP = clamp(HP, 0, max_HP)
	if is_multiplayer_authority():
		player_ui_instance.update_UI(HP, max_HP)

func setup_camera():
	if is_multiplayer_authority():
		camera_control.camera_3d.current = true  # Активируем камеру только для локального игрока
	else:
		camera_control.camera_3d.current = false  # Деактивируем камеру для других игроков

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func inv_vis():
	if inventory_ui_instance.is_visible():
		inventory_ui_instance.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		inventory_ui_instance.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func set_nickname():
	label_3d.text = str(get_multiplayer_authority())

func get_instance_ui():
	if is_multiplayer_authority():
		player_ui_instance = player_ui.instantiate()
		add_child(player_ui_instance)
		inventory_ui_instance = inventory_ui.instantiate()
		add_child(inventory_ui_instance)
		inventory_ui_instance.hide()

func dead():
	is_dead = true
	EventsGlobal.emit_signal("end")

