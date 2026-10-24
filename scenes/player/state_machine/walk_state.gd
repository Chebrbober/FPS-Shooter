class_name Walk extends State

@export var walk_speed: float = 3.0

func enter() -> void:
	actor.tween_fov(actor.normal_FOV)

func physics_update(delta: float) -> void:
	actor.speed = walk_speed
	actor.stamina += actor.stamina_cost * delta

	if not actor.is_moving:
		state_machine.transition_to("Idle")
	if Input.is_action_pressed("sprint") and actor.stamina >= 50.0:
		state_machine.transition_to("Sprint")
