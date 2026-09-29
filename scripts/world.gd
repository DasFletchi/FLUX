extends Node3D

var peer = ENetMultiplayerPeer.new()
var PORT = 9999
@export var player_scene : PackedScene





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_host_pressed() -> void:
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)






func _on_join_pressed() -> void:
	pass # Replace with function body.


func add_player(id = 1):
	var player = player_scene.instantiate()
	player.name =  str(id) #I think we can change that name with something the use rcan come up with its own mind, it just needs to be a a unique name per session
	call_deferred("add_child")
