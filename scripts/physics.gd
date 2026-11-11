class_name VPhysics
extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func snap_position(pos: Vector3) -> Vector3: #in the bracket is what the function takes, out of the bracket is what it gives (good relationship lol)
	return Vector3(
		snappedf(pos.x, 0.25),
		snappedf(pos.y, 0.25),
		snappedf(pos.z, 0.25),
	)
