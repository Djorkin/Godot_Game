extends Node

@export var player_scene: PackedScene
var items_script = load("res://Scripts/Items.gd")
var items: Items = Items.new()
var peer = ENetMultiplayerPeer.new()
const PORT = 7777
const MAX_CONNECTIONS = 3
const DEFAULT_SERVER_IP = "127.0.0.1"



func _ready():
	EventsGlobal.end.connect(end_game)
	EventsGlobal.host.connect(create_server)
	EventsGlobal.client.connect(create_client)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()

func _process(_delta):
	pass

func create_server():
	peer.create_server(PORT, MAX_CONNECTIONS)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()
	check_server_status()

func check_server_status():
	if multiplayer.is_server():
		print("Сервер работает")
	else:
		print("Сервер не активен")

func add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)
	print("Игрок добавлен " +  str(player.name))

func create_client():
	peer.create_client(DEFAULT_SERVER_IP, PORT)
	multiplayer.multiplayer_peer = peer

func end_game():
	get_tree().quit()
