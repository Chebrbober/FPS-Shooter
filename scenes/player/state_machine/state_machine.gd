class_name StateMachine extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_machine = self
			child.actor = get_parent()

	if initial_state:
		current_state = initial_state
		current_state.enter()

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func transition_to(target_state_name: String) -> void:
	var target_state = states.get(target_state_name.to_lower())
	if not target_state:
		print("didn't found target state:", target_state, "by it's name:", target_state_name)
		return

	if current_state:
		current_state.exit()

	current_state = target_state
	current_state.enter()
	print("changed state", current_state)
