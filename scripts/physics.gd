class_name VPhysics
#da diese funktion nur mathe ist mssen wir das hier auch an gar nichts childen oder so was doch tbh schonmal sehr nice ist. wir müssen jedoch den block interactor childen weil @rpc kann man nicht mit einer static klasse machen. Ausserdem müssen die cams ja auch um den raycast zu schiesen an jedem einzelnden spieler dran sein und shit. 
extends Node

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") #DAS IST EINE FLOAT KEIN VECTOR


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func calc_pos_caller():
	if is_multiplayer_authority():
		if not time:
			var time = 0
		time = time + 0.1
		calc_pos()


func calc_pos(starting_pos: Vector3, velocity: Vector3, time: float):
	var future_position = (
		starting_pos
		+ velocity * time
		+ 0.5 * gravity * time * time
	)
	#hätte ich auch hier als one liner schreiben könne aber so ist es leserlicher macht keinen unterschied ausser für dich der das hieer grade liest
	return future_position


func calc_pos_checker(future_position: Vector3):
	



## QUANTIZISING THE POSITION
func snap_position(pos: Vector3) -> Vector3: #in the bracket is what the function takes, out of the bracket is what it gives (good relationship lol)
	return Vector3(
		snappedf(pos.x, 0.25),
		snappedf(pos.y, 0.25),
		snappedf(pos.z, 0.25),
	)
## snapped() woudve worked here aswell but idk with the f it can only handle floats wich idk why not
