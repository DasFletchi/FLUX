@tool
extends VoxelGeneratorScript

@export var meadow_generator: VoxelGeneratorGraph
@export var desert_generator: VoxelGeneratorGraph
@export var biome_noise: FastNoiseLite


func _get_used_channels_mask() -> int: #bevor wir viel platz pro chunk wasten sagen wir welche channel mask wir überhaupt wollen (in dem fall TYPE für Voxel terrain)
	return 1 << VoxelBuffer.CHANNEL_TYPE #Voxelbuffer ist die schüssel in die die ganzen voxel reinkommen, warum das so geschrieben werden muss checke ich nicht aber idc wir werden nur einen terrain generator schreiben (hoffe ich lowk)

func _generate_block(out_buffer: VoxelBuffer, origin_in_voxels: Vector3i, lod: int) -> void:
#calcucate the middle of the chunk
	var chunk_center_x := origin_in_voxels.x + 8 #the "." before the "=" does that godot does jnt have to check everytime if the var has changed, wich gives us a little squeeze of performance more.
	var chunk_center_z := origin_in_voxels.z + 8
	var noise_val := 0.0
	if biome_noise != null:
		noise_val = biome_noise.get_noise_2d(chunk_center_x, chunk_center_z)
	
