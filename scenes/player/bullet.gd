extends Node3D

@export var speed: float = 40.0

@onready var mesh = $MeshInstance3D
@onready var shape_cast = $ShapeCast3D
@onready var particles = $GPUParticles3D

func _physics_process(delta: float) -> void:
	position += transform.basis * Vector3(0,0, -speed) * delta
	if shape_cast.is_colliding():
		mesh.visible = false
		particles.emitting = true
		await get_tree().create_timer(1.0).timeout
		queue_free()

func _on_timer_timeout():
	queue_free()
