class_name BlockInteractor
extends Node
@onready var camera_3d: Camera3D = $"../Camera3D"

var voxel_tool: VoxelTool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var terrain := get_parent().get_parent().get_node_or_null("VoxelTerrain") as VoxelTerrain #das walross kann hier noch nicht predicten was das überhaupt ist das führt dazudas wir nur dieocmpletions von einer normalen node rkeigen würden also schieben wir ihm hier in den arsch das es VoxelTerrain GDScriptNativeClass ist
	if terrain:
		voxel_tool = terrain.get_voxel_tool()


func pick_block(): 
	var voxel_result: VoxelRaycastResult = voxel_tool.raycast(camera_3d.global_position, -camera_3d.global_transform.basis.z, 3) #hier packen wir ein voxel raycast result hin WEIL WIR HIER DEKLARIEREN DAS DARF NUR EINMAL HIN DAS HEIST NUR DU BIST VON DEM TYPE, damit der godot compiler weis was genau er autocompleten kann etc
	if voxel_result:
		print(voxel_result.position)
		return voxel_result

@rpc("reliable", "any_peer", "call_local") # call local muss darein weil Godot sonst eine Diva ist und wenn der server selber einen block removen will würde er sich sonst blocken weil er ja schon der empfänger ist
func delete_block(voxel_result2):
	if multiplayer.is_server():
		if voxel_result2 != Vector3i.ZERO: #just preventing the game crashing when voxel_result2 is a null bc for example it didnt catch a block in its 3 blocks range
			voxel_tool.set_voxel(voxel_result2, 0) #nicht die klassen einfach so reinschrieben godot kann keine gedanken elsen, eimnfach IMMER variablen nutzen er hat den context nicht aber wenn man eine var über ein GDScriptnative class object macht dann schon
			print("Block at: ", voxel_result2, " was successfully removed")

@rpc("reliable", "any_peer", "call_local")
func request_delete_block():
	var voxel_result2 = pick_block()
	
	if voxel_result2:
		delete_block.rpc_id(1, voxel_result2.position)
#hier nicht voxel_result.position weil i gueess die Vector3i ist eh schon die position und die gibt halt dieser raycast dann aus meine fresse woher soll ich das wissen ugh gott


func change_block():
	pass
