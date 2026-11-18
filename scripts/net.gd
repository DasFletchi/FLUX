extends Node

func server_function(function_name: String, data_for_func: Array = []):
	var world = get_tree().current_scene
	if multiplayer.is_server():
		world.callv(function_name, data_for_func)
	else:
		_send_to_server.rpc_id(1, function_name, data_for_func)


@rpc("reliable", "any_peer")
func _send_to_server(function_name: String, data_for_func: Array = []):
	if multiplayer.is_server():
		var world = get_tree().current_scene
		world.callv(function_name, data_for_func)


# ==============================================================================
# EXAMPLES & USAGE GUIDE:
# ==============================================================================
#
# 1. Where does the actual function live?
#    -> Always declare it normally inside 'world.gd':
#       func spawn_loose_block(pos: Vector3i, block_id: int):
#           ...
#
# 2. How do you call it from anywhere (e.g. inside player.gd on click)?
#    -> With 2 parameters (position + block type):
#       Net.server_function("spawn_loose_block", [hit_pos, block_id])
#
#    -> With 1 parameter (only position):
#       Net.server_function("delete_block", [hit_pos])
#
#    -> With 0 parameters (empty square brackets):
#       Net.server_function("reset_day_night_cycle", [])
# ==============================================================================
