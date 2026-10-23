extends CharacterBody3D

@export_group("Movement")
@export var speed: float = 5.0
@export var acceleration: float = 25.0
@export var jump_velocity: float = 5.0
@export var gravity = 9.8

@export_group("Camera")
@export var sensitivity: float = 0.003
@export var camera_min_pitch: float = -75.0
@export var camera_max_pitch: float = 75.0

@onready var camera: Camera3D = $Camera3D

@export_subgroup("Camera Presets")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	move(delta)
	jump(delta)
	move_and_slide()

func jump(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	if not is_on_floor():
		velocity.y -= gravity * delta

func move(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = move_toward(velocity.x, direction.x*speed, acceleration*delta)
		velocity.z = move_toward(velocity.z, direction.z*speed, acceleration*delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, acceleration * delta)
		velocity.z = move_toward(velocity.z, 0.0, acceleration * delta)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(
			camera.rotation.x,
			deg_to_rad(camera_min_pitch),
			deg_to_rad(camera_max_pitch)
		)
