class_name Idle extends State

func enter() -> void:
	actor.tween_fov(actor.normal_FOV)

func physics_update(delta: float) -> void:
	actor.stamina += actor.stamina_cost * delta

	if actor.is_moving:
		state_machine.transition_to("Sprint" if Input.is_action_pressed("sprint") and actor.stamina >= 50.0 else "Walk")
