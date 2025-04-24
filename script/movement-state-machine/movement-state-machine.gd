class_name MovementStateMachine
extends StateMachine

var states = {}
var current_state: State = null

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.state_machine = self
			child.set_process(false)
			child.set_physics_process(false)

func change_state(new_state_name: String) -> void:
	if not states.has(new_state_name):
		push_error("Movement State machine doesn't have state: %s" % new_state_name)
		return
	
	var new_state: State = states[new_state_name]
	if current_state: 
		current_state.exit(new_state)
		current_state.set_process(false)
		current_state.set_physics_process(false)
	new_state.enter(current_state)
	new_state.set_process(true)
	new_state.set_physics_process(true)
	current_state = new_state

func _input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)
