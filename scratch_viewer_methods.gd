extends SceneTree

func _init():
	var viewer = VoxelViewer.new()
	for m in viewer.get_method_list():
		print(m.name)
	quit()
