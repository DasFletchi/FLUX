class_name LooseBlock
extends RigidBody3D

## Continuous Collision Detection: Verhindert Tunneling/Durch-die-Wand-Glumpen bei hohen Geschwindigkeiten.
@export var enable_ccd: bool = true:
	set(val):
		enable_ccd = val
		continuous_cd = val

func _ready() -> void:
	continuous_cd = enable_ccd
