class_name VPhysics
extends Node

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func calc_pos_caller():
	var time = 0
	time = time + 0.1
	print("baguette")
	


func calc_pos(starting_pos: Vector3, velocity: Vector3, time: float):
	var future_position = (
		starting_pos
		+ velocity * time
		+ 0.5 * gravity * time * time
	)
	
	#hätte ich auch hier als one liner schreiben könne aber so ist es leserlicher
	return future_position



## QUANTIZISING THE POSITION
func snap_position(pos: Vector3) -> Vector3: #in the bracket is what the function takes, out of the bracket is what it gives (good relationship lol)
	return Vector3(
		snappedf(pos.x, 0.25),
		snappedf(pos.y, 0.25),
		snappedf(pos.z, 0.25),
	)
