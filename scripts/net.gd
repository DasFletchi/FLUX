extends Node

func server_function(target_node: Node, function_name: String, data_for_func: Array = []):
	if multiplayer.is_server():
		target_node.callv(function_name, data_for_func)  #calls a function in this script (whatever the name of that function may be) just makes it less annoying for me right now because I dont have to integrate 7billion functions into this, v in callv steht dafür das man die argumente für die funktion als Array/Vector gibt
	else:
		_send_to_server.rpc_id(1, target_node.get_path(), function_name, data_for_func)




@rpc("reliable", "any_peer")
func _send_to_server(path: NodePath, function_name: String, data_for_func: Array = []): # having the underscore in front of the function name is just a naming convention to show that this function is private and should not be called from outside this script, but it is still public because it is an RPC function. This makes Tab-completions less annoying
	if multiplayer.is_server(): #just an extra check to make sure the server is the one that is calling this function, because if a client calls this function it will just be ignored and not do anything
		get_node(path).callv(function_name, data_for_func)
