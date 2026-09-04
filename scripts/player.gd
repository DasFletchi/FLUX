extends CharacterBody3D

@onready var camera_3d: Camera3D = $Camera3D

@export var SPEED = 4.317
var current_speed
const JUMP_VELOCITY = 6.42


@export var mouse_sensitivity: float = 0.002

func _physics_process(delta: float) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction.
	var input_dir := Input.get_vector("a", "d", "w", "s")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# 1. ZUERST den Speed für diesen Frame festlegen (bevor bewegt oder gebremst wird!)
	current_speed = SPEED
	if Input.is_action_pressed("shift"):
		current_speed = SPEED * 1.3 # Setzt den Sprint-Speed sauber fest

	# 2. JETZT die Bewegung berechnen (current_speed ist jetzt NIEMALS mehr Nil)
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()




func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera_3d.rotate_x(-event.relative.y * mouse_sensitivity)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, -PI/2, PI/2) #clamped halt die rotation um x rum die hälfte von PI (180) auf beiden seiten
