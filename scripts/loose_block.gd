class_name LooseBlock
extends RigidBody3D

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

## Continuous Collision Detection: Verhindert Tunneling/Durch-die-Wand-Glumpen bei hohen Geschwindigkeiten.
@export var enable_ccd: bool = true:
	set(val):
		enable_ccd = val
		continuous_cd = val

func _ready() -> void:
	continuous_cd = enable_ccd


func set_material(material: Material) -> void:
	mesh_instance.material_override = material #nice
