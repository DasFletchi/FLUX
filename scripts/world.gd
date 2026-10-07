extends Node3D

var enet_peer = ENetMultiplayerPeer.new()
var PORT = 6931
@export var player_scene : PackedScene

@onready var host: Button = $CanvasLayer/VBoxContainer/HOST
@onready var join: Button = $CanvasLayer/VBoxContainer/JOIN
@onready var canvas_layer: CanvasLayer = $CanvasLayer


func _ready() -> void:
	multiplayer.connected_to_server.connect(func(): print("[NET CLIENT] Connected to server! My peer ID: ", multiplayer.get_unique_id()))
	multiplayer.connection_failed.connect(func(): print("[NET CLIENT ERROR] Connection to server failed!"))
	multiplayer.server_disconnected.connect(func(): print("[NET CLIENT] Server disconnected!"))
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(func(id): print("[NET EVENT] Peer disconnected with ID: ", id))

func _on_host_pressed() -> void:
	print("[WORLD] HOST button pressed.")
	var err = enet_peer.create_server(PORT)
	print("[WORLD] create_server result: ", err, " (0 = OK)")
	multiplayer.multiplayer_peer = enet_peer
	canvas_layer.hide()
	print("[WORLD] Spawning host with add_player(1)... My unique ID: ", multiplayer.get_unique_id())
	add_player(1) #1 in godot always means authority

func _on_join_pressed() -> void:
	print("[WORLD] JOIN button pressed.")
	var err = enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer
	print("[WORLD] create_client result: ", err, " (0 = OK) | My unique ID: ", multiplayer.get_unique_id())
	canvas_layer.hide()
	print("[WORLD] Calling add_player(name.to_int())... World node name: '", name, "' -> name.to_int(): ", name.to_int())


func add_player(id = 1):
	print("[WORLD] add_player called with id: ", id)
	var player = player_scene.instantiate() #instanciating this will only add it to the RAM, no place it in the game world. 
	player.name =  str(id) #I think we can change that name with something the use rcan come up with its own mind, it just needs to be a a unique name per session
	print("[WORLD] Instantiated player with node name: '", player.name, "'. Adding child deferred...")
	call_deferred("add_child", player) #call deferred just means "call this when youre finished with your current task"


func kick_player(id):
	print("[WORLD] kick_player called for id: ", id)
	rpc("_kick_player", id)

@rpc("any_peer", "call_local")
func _kick_player(id):
	print("[WORLD] _kick_player called for id: ", id)
	if has_node(str(id)):
		get_node(str(id)).queue_free()
	else:
		print("[WORLD ERROR] Node '", str(id), "' not found to remove!")


func exit_game(id):
	multiplayer.peer_disconnected.connect(_kick_player)
	kick_player(id)


func _on_peer_connected(id):
	if not multiplayer.is_server():
		return
	print("New player joined! Network ID: ", id)
	add_player(id)
