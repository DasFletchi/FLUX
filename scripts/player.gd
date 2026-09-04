extends CharacterBody3D

@onready var camera_3d: Camera3D = $Camera3D

@export var SPEED = 4.317
@export var auto_jump_cooldown = 0.3
@export var JUMP_VELOCITY = 6.42
@export var mouse_sensitivity: float = 0.002


var current_speed
var jump_cooldown: float = 0.0

func _ready() -> void:
	var terrain = get_parent().get_node_or_null("VoxelTerrain") #zieht sich die voxel terrain node und ist fine wenn er null kriegt
	if terrain: #wenn er einen terrain findet/wenn terrain fine ist
		set_physics_process(false)
		while not terrain.is_area_meshed(AABB(terrain.to_local(global_position) - Vector3(1, 2, 1), Vector3(2, 2, 2))): #hier braucht man warum auch immer diesen crazy shit we mit to local weil wir unsere welt ja in der transform auf 0.25 haben. und mit dem vecor minus ding type shit da das ist für die AABB, wo die spawnen soll und checken soll
			await get_tree().process_frame #ALLES WAS IN READY UNTER DIESER SCHLEIFE STEHT SKIPPEN
		set_physics_process(true)

func _physics_process(delta: float) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	
	if Input.is_action_just_pressed("space") and is_on_floor(): #you can still jump faster than that by murdering ur spacebar
		velocity.y = JUMP_VELOCITY
	
	if jump_cooldown > 0.0: #Läuft die Stoppuhr gerade noch?
		jump_cooldown -= delta #Ziehe die vergangene Zeit (0,016s) von der Restzeit ab.
	if Input.is_action_pressed("space") and is_on_floor() and jump_cooldown <= 0.0:
		velocity.y = JUMP_VELOCITY
		jump_cooldown = auto_jump_cooldown
	
	
	
	# Get the input direction.
	var input_dir := Input.get_vector("a", "d", "w", "s")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# 1. ZUERST den Speed für diesen Frame festlegen (bevor bewegt oder gebremst wird!)
	current_speed = SPEED
	if Input.is_action_pressed("shift"):
		current_speed = SPEED * 1.3 # Setzt den Sprint-Speed sauber fest

	# 2. JETZT die Bewegung berechnen
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
