extends Node3D

var enet_peer = ENetMultiplayerPeer.new()
var PORT = 6931
@export var player_scene : PackedScene

@onready var host: Button = $CanvasLayer/VBoxContainer/HOST
@onready var join: Button = $CanvasLayer/VBoxContainer/JOIN
@onready var canvas_layer: CanvasLayer = $CanvasLayer


func _on_host_pressed() -> void:
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	canvas_layer.hide()
	add_player(1) #1 in godot always means authority

func _on_join_pressed() -> void:
	multiplayer.multiplayer_peer = enet_peer
	enet_peer.create_client("localhost", PORT)
	canvas_layer.hide()
	add_player(name.to_int())

func add_player(id = 1):
	var player = player_scene.instantiate()
	player.name =  str(id) #I think we can change that name with something the use rcan come up with its own mind, it just needs to be a a unique name per session
	call_deferred("add_child", player) #call deferred just means "call this when youre finished with your current task"


func kick_player(id):
	rpc("_kick_player", id)
@rpc("any_peer", "call_local")


func _kick_player(id):
	get_node(str(id)).queue_free()


func exit_game(id):
	multiplayer.peer_disconnected.connect(_kick_player)
	kick_player(id)
