class_name Sprint extends State

@export var sprint_speed: float = 5.0

func enter() -> void:
	actor.tween_fov(actor.sprint_FOV)

func exit() -> void:
	actor.tween_fov(actor.normal_FOV)

func physics_update(delta: float) -> void:
	actor.speed = sprint_speed
	actor.stamina -= actor.stamina_cost * delta

	if actor.stamina <= 0.0:
		actor.stamina = 0
		state_machine.transition_to("Exhausted")
	elif not Input.is_action_pressed("sprint") or not actor.is_moving:
		state_machine.transition_to("Walk" if actor.is_moving else "Idle")
