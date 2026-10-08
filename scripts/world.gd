extends Node3D

var enet_peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene

@onready var host: Button = $CanvasLayer/VBoxContainer/HOST
@onready var join: Button = $CanvasLayer/VBoxContainer/JOIN
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var join_line_edit: LineEdit = $CanvasLayer/VBoxContainer/JoinLineEdit

const NORAY_HOST = "tomfol.io"
const NORAY_PORT = 8890 #i cant just imageine a random fucking code right here because the noray server only listens to that port.


func _ready() -> void:
	multiplayer.connected_to_server.connect(func(): print("[NET CLIENT] Connected to server! My peer ID: ", multiplayer.get_unique_id()))
	multiplayer.connection_failed.connect(func(): print("[NET CLIENT ERROR] Connection to server failed!"))
	multiplayer.server_disconnected.connect(func(): print("[NET CLIENT] Server disconnected!"))
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(func(id): print("[NET EVENT] Peer disconnected with ID: ", id))

func _on_host_pressed() -> void:
	var errConnectNorayRelayServer = await Noray.connect_to_host(NORAY_HOST, NORAY_PORT)
	print("[WORLD] Noray.connect_to_host(NORAY_HOST, NORAY_PORT) result: ", errConnectNorayRelayServer, " (0 = OK)")
	print("[WORLD] HOST button pressed.")
	var errNorayRegisterHost = Noray.register_host()
	print("[WORLD] Registering Noray host")
	print("[WORLD] Noray.register_host() result: ", errNorayRegisterHost, " (0 = OK)")
	await Noray.on_pid
	print("[WORLD] MY OID: ", Noray.oid)
	await Noray.register_remote()
	print("[WORLD] My own port: ", Noray.local_port)
	var err = enet_peer.create_server(Noray.local_port)
	print("[WORLD] create_server result: ", err, " (0 = OK)")
	multiplayer.multiplayer_peer = enet_peer
	Noray.on_connect_nat.connect(nat_connect)
	Noray.on_connect_relay.connect(relay_connect)
	canvas_layer.hide()
	print("[WORLD] Spawning host with add_player(1)... My unique ID: ", multiplayer.get_unique_id())
	add_player(1)

func _on_join_pressed() -> void:
	print("[WORLD] JOIN button pressed.")
	await Noray.connect_to_host(NORAY_HOST, NORAY_PORT)
	print("[WORLD] Connecting to Noray Server.")
	join.hide()
	join_line_edit.show()
	var host_oid = join_line_edit.text
	if host_oid.is_empty():
		push_error("[WORLD] Insert OID code please")
		return
	var err = Noray.register_host()
	print("Noray Registering host ERROR CODE: ", err)
	
	await Noray.on_pid
	await Noray.register_remote()
	Noray.on_connect_nat.connect(join_game)
	print("trying to join game over nat")
	Noray.on_connect_relay.connect(join_game)
	print("trying to join game over relay")
	Noray.connect_nat(host_oid)
	canvas_layer.hide()


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

func nat_connect(address: String, port: int) -> void:
	await PacketHandshake.over_enet_peer(enet_peer, address, port)
	print("[MultiplayerManager] NAT connection from: ", address, ":", port)

func relay_connect(address: String, port: int) -> void:
	await PacketHandshake.over_enet_peer(enet_peer, address, port)
	print("[MultiplayerManager] Relay connection from: ", address, ":", port)


func join_game(address: String, port: int) -> void:
	enet_peer.create_client(address, port, 0, 0, 0, Noray.local_port) #we need the zeros just because 0 means unlimited
	multiplayer.multiplayer_peer = enet_peer #we cant do this before hand because godot only takes stuff that arent husks
