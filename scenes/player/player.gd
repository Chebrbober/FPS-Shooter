extends CharacterBody3D

@export_group("Movement")
@export var speed: float = 3.0
@export var acceleration: float = 25.0
@export var jump_velocity: float = 5.0
@export var gravity: float = 9.8
@export_range(0,100) var stamina: float = 100
@export var stamina_cost: float = 25

signal stamina_changed(current: float)

@export_group("Camera")
@onready var camera: Camera3D = $Camera3D
@export var sensitivity: float = 0.003
@export var camera_min_pitch: float = -75.0
@export var camera_max_pitch: float = 75.0
@export_range(1, 179) var sprint_FOV: float = 100
@export_range(1, 179) var normal_FOV: float = 75

@export_group("Bullet")
@onready var gun_anim: AnimationPlayer = $Camera3D/Rifle/AnimationPlayer
@onready var gun_barrel: RayCast3D = $Camera3D/Rifle/RayCast3D
@export var bullet: PackedScene
var bullet_instance: Node3D

var tween: Tween
var is_moving: bool = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	move(delta)
	jump(delta)
	shoot()
	move_and_slide()

func shoot() -> void:
	if Input.is_action_pressed("shoot"):
		if !gun_anim.is_playing():
			gun_anim.play("Shoot")
			bullet_instance = bullet.instantiate()
			bullet_instance.position = gun_barrel.global_position
			bullet_instance.transform.basis = gun_barrel.global_transform.basis
			get_parent().add_child(bullet_instance)

func jump(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	if not is_on_floor():
		velocity.y -= gravity * delta

func move(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	is_moving = input_dir != Vector2.ZERO
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = move_toward(velocity.x, direction.x*speed, acceleration*delta)
		velocity.z = move_toward(velocity.z, direction.z*speed, acceleration*delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, acceleration * delta)
		velocity.z = move_toward(velocity.z, 0.0, acceleration * delta)

	stamina = clamp(stamina, 0.0, 100.0)
	stamina_changed.emit(stamina)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(
			camera.rotation.x,
			deg_to_rad(camera_min_pitch),
			deg_to_rad(camera_max_pitch)
		)

func tween_fov(target_fov: float) -> void:
	if not camera: return
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(camera, "fov", target_fov, 0.75).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	print("changed_fov")
