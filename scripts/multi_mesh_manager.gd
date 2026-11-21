extends Node3D
#this script is gonna spawn a new multimesh instance for each new block

@export var visible_instance_count: int = 0
@export var instance_count: int = 1000
@export var block_size: Vector3 = Vector3(0.5, 0.5, 0.5)

@onready var world: Node3D = $".."

var space: RID #RID stands for Resource ID, and is a low-level handle to a resource in Godot. In this case, it's used to reference the physics space of the world.
var shared_shape: RID

# In low-level Godot, I need these just like other variables to pass into functions and do stuff with them.
# HOWEVER, 'shared_shape' is not the box shape information itself, but only points to it,
# because there is only one central physics server. Imagine it like in a club you get your ID for the jacket and then you can tell
# the staff with your id what you want to do with that, you dont do It yourself, because again there's only one central physics server.


# Das Dictionary speichert keine Kopien, sondern fungiert wie ein Symlink / Wegweiser direkt auf das echte MMI im Szenenbaum.
var active_multimeshes: Dictionary = {}
var block_bodies: Dictionary = {}

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
		# now starts the part where we start to become little hackers lol. now where pushing stuff around in the CPU's L1 Cache (i jsut wanted to say the word "L1 Cache" it sounds so smart idk, prolyl is true though)
		var body: RID = PhysicsServer3D.body_create() #just the new object we will configure now we coudve named it anything else, it irrelevant its just a name
		PhysicsServer3D.body_add_shape(body, shared_shape)
		PhysicsServer3D.body_set_space(body, space)
		PhysicsServer3D.body_set_mode(body, PhysicsServer3D.BODY_MODE_RIGID) #making this as an RID would give us no extra performance because it is litterally just a number 0 is Static 1 is Kinematic (only changeable with code) 2 is Rigid (behaviour like a rigidbodie like the name sais lol)
		var body_transform = Transform3D(Basis(), position)
		PhysicsServer3D.body_set_state(body, PhysicsServer3D.BODY_STATE_TRANSFORM, body_transform)
		if not block_bodies.has(block_id):
			block_bodies[block_id] = [] #dann machen wir dafür platz i mdict und packen da ein array rein, das array hält dann alle blöcke dieses typs
		block_bodies[block_id].append(body) #jetzt packen wir den body in das array rein, das wir gerade gemacht haben
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
	for block_id in block_bodies: #macht hier kurz on the fly eine neue var mit dem namen block_id und geht die dann hoch
		# gehe durch jede block_id, die in block_bodies existiert
		var mmi2 = active_multimeshes[block_id] #i just like to make it 2 because why not idk, this grabs the right MultiMeshInstance3D
		var bodies = block_bodies[block_id] #this grabs the right array of RIDs for this block_id, now we need to choose wich one to change/link the position to


		# Warum rückwärts zählen mit range(bodies.size() - 1, -1, -1)?
		# Stell dir eine Schlange vor: Platz 0 (Anton), Platz 1 (Berta), Platz 2 (Caesar).
		# Wenn du vorwärts zählst und Anton (0) löschst, rücken Berta und Caesar auf (Berta wird 0, Caesar wird 1).
		# Der Loop springt aber stur zu Platz 1 (Caesar) -> Berta wird komplett übersprungen!
		# Und bei Platz 2 crasht Godot, weil es Platz 2 gar nicht mehr gibt (Index out of bounds).
		# Beim RÜCKWÄRTS zählen (2 -> 1 -> 0) löscht man von hinten: Vorne verschiebt sich nichts, niemand wird übersprungen und nix crasht!
		for index in range(bodies.size() - 1, -1, -1):
			var body_transform = PhysicsServer3D.body_get_state(bodies[index], PhysicsServer3D.BODY_STATE_TRANSFORM)
			mmi2.multimesh.set_instance_transform(index, body_transform)
			# Godot's PhysicsServer3D doesn't have separate functions like 'body_is_sleeping()' or 'body_get_position()', because the devs were lazy (ofc).
			# Instead, it uses one universal query function: 'body_get_state(who, what_to_check)'.
			# 1st param: Which physics body (bodies[index])
			# 2nd param: What state to check (e.g. BODY_STATE_TRANSFORM or BODY_STATE_SLEEPING)
			var sleeping = PhysicsServer3D.body_get_state(bodies[index], PhysicsServer3D.BODY_STATE_SLEEPING)
			if sleeping: #sleeping means Vector3.ZERO, just in a low level PhysicsServer3D Language
				print("[MULTI MESH MANAGER] Block at index ", index, " for block ID ", block_id, " is not moving. Removing from MultiMeshInstance and physics bodies.")
				PhysicsServer3D.free_rid(bodies[index]) # Free the RID to avoid memory leaks
				bodies.remove_at(index) # Remove the body from the array, I mean yeah it is just a local var but it is linked with the main array from the top so its fine if we remove it from here it will be removed from the top array aswell :3 It's just a symlink/reference/Wegweiser. Simple numbers like int and float's just get copied. But Arrays and Dictionaries get linked (referenced)
				mmi2.multimesh.visible_instance_count -= 1 # Decrease the visible instance count
#erase MultiMeshInstances3D from scene tree and Dictionary when not needed anymore



func _ready() -> void:
	space = world.get_world_3d().space
	shared_shape = PhysicsServer3D.box_shape_create()
	PhysicsServer3D.shape_set_data(shared_shape, block_size * 0.5) #we need the * 0.5 because the low level Godot uses half extends means we gotta half our values because it starts from the center
	# This part of the game needs "hyperoptimization", it is shaving of compute if we set this one time in the ready. Instead of everytime when we're creating a new block in the spb() function
