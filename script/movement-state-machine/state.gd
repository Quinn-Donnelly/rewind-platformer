extends Node
class_name State

var state_machine: StateMachine

func enter(_previous_state: State) -> void:
	pass
	
func exit(_next_state: State) -> void:
	pass

# State Machine will control enable and disable
func _physics_process(delta: float) -> void:
	pass
	
func _process(delta: float) -> void:
	pass
	
func handle_input(input: InputEvent) -> void:
	pass

func can_transition(state: State) -> bool:
	return true
