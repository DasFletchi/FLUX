extends MultiMeshInstance3D

var active_blocks: Array[RID]
var shared_shape: RID
var space: RID

@onready var loose_blocks: MultiMeshInstance3D = $"."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	space = get_world_3d().space
	shared_shape = PhysicsServer3D.box_shape_create()
	PhysicsServer3D.shape_set_data(shared_shape, Vector3(0.25, 0.25, 0.25)) #why the 0.25 instead of the 0.5 when our blocks are 0.5m? Godot's high level approach is easy with you being able to just put in the full lenght, however godot's low level approach (this) is a bit more complicated and you have to put in half the length, so 0.25 instead of 0.5
	multimesh.instance_count = 1000 #we dont want to change that on the node (the node actually doesnt even have that feature, we wanna change the ressource) (bilderrahmen)
	multimesh.visible_instance_count = 0



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn_loose_block(position: Vector3, block_id: int):
	multimesh.visible_instance_count += 1
