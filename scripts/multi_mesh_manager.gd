extends Node3D
#this script is gonna spawn a new multimesh instance for each new block

@export var visible_instance_count: int = 0
@export var instance_count: int = 1000
@export var block_size: Vector3 = Vector3(0.5, 0.5, 0.5)

@onready var world: Node3D = $".."


# Das Dictionary speichert keine Kopien, sondern fungiert wie ein Symlink / Wegweiser direkt auf das echte MMI im Szenenbaum.
var active_multimeshes: Dictionary = {}

var block_materials_in_int = {
	1: preload("res://scenes/blocks/materials/grass.tres"),
	2: preload("res://scenes/blocks/materials/dirt.tres"),
	3: preload("res://scenes/blocks/materials/stone.tres"),
	4: preload("res://scenes/blocks/materials/sandstone.tres"),
	5: preload("res://scenes/blocks/materials/loam.tres"),
	6: preload("res://scenes/blocks/materials/oak.tres"),
}


func spb(block_id: int, position: Vector3) -> void:
	if active_multimeshes.has(block_id):
		print("[MULTI MESH MANAGER] Adding block to existing MultiMeshInstance for block ID: ", block_id)
		var mmi = active_multimeshes[block_id]
		var instance_id = mmi.multimesh.visible_instance_count
		mmi.multimesh.set_instance_transform(instance_id, Transform3D(Basis(), position))
		mmi.multimesh.visible_instance_count += 1
	else:
		print("[MULTI MESH MANAGER] Creating new MultiMeshInstance for block ID: ", block_id)
		_spawn_new_mmi(block_id)
		spb(block_id, position) #recursive call to add the block after creating the new MultiMeshInstance



func _spawn_new_mmi(block_id: int) -> void:
	var mmi = MultiMeshInstance3D.new()
	mmi.name = str("MultiMeshInstance: ", block_id)

	mmi.multimesh = MultiMesh.new()
	mmi.multimesh.mesh = BoxMesh.new()
	mmi.multimesh.mesh.material = block_materials_in_int[block_id]
	mmi.multimesh.mesh.size = block_size

	mmi.multimesh.transform_format = MultiMesh.TRANSFORM_3D
	mmi.multimesh.instance_count = instance_count
	mmi.multimesh.visible_instance_count = visible_instance_count

	add_child(mmi)
	active_multimeshes[block_id] = mmi #with this we save this new mmi unter its block id wich is an integer, dang we writing some smart code today lol
	print("[MULTI MESH MANAGER] New MultiMeshInstance created for block ID: ", block_id, " | Total active MultiMeshInstances: ", active_multimeshes.size())



func _physics_process(delta: float) -> void: # we need the underscore, because else Godot wont recognize the physics process as physics process
	#erase MultiMeshInstances3D from scene tree and Dictionary when not needed anymore
	pass
