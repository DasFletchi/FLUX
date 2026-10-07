extends SceneTree

func _init():
	var viewer = VoxelViewer.new()
	for p in viewer.get_property_list():
		print(p.name, ": ", p.type)
	quit()
