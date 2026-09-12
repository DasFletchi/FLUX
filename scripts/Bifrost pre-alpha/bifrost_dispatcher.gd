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
	var chunk_center_z := origin_in_voxels.z + 8 #we just do that for more accurate biomes
	var noise_val := 0.0
	if biome_noise != null:
		noise_val = biome_noise.get_noise_2d(chunk_center_x, chunk_center_z)
		
		if noise_val < 0.0: #values from -1 to 1
			if desert_generator != null: #checking if we even got a desert_generator, if not, then dont do this code under this
				desert_generator.generate_block(out_buffer, origin_in_voxels, lod) #dont get confused, if you played minecraft you know that 16³ blocks are a chunk. But in Zylanns C++ code one block is a chunk. So one block  (of voxels) is 16³ blocks in code
				# origin in voxels is needed for the Noise3D that we will need in the graph, and out_buffer is just the basket that get for transporting  this to the voxelGraph, the buffer thingy reserves some ram for 4.096 Voxels
				
		else: #tabbed in here so we only do else if value is above 1
			if meadow_generator != null:
				meadow_generator.generate_block(out_buffer, origin_in_voxels, lod)
