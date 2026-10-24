class_name Exhausted extends State

func enter() -> void:
	actor.tween_fov(actor.normal_FOV)
	actor.speed = 3.0

func physics_update(delta: float) -> void:
	actor.stamina += actor.stamina_cost * delta

	if actor.stamina >= 50.0:
		state_machine.transition_to("Walk" if actor.is_moving else "Idle")
