class_name BInteractor
extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var terrain := get_parent().get_parent().get_node_or_null("VoxelTerrain") as VoxelTerrain #das walross kann hier noch nicht predicten was das überhaupt ist das führt dazudas wir nur dieocmpletions von einer normalen node rkeigen würden also schieben wir ihm hier in den arsch das es VoxelTerrain GDScriptNativeClass ist
	if terrain:
		var voxel_tool = terrain.get_voxel_tool()

func pick_block():
	pass



func delete_block():
	pass


func change_block():
	pass
