extends State
class_name Idle

func enter(previous_state: State) -> void:
	$"../../Charecter".animation = "idle"
	if previous_state is Fall and previous_state.bufferedJump:
		state_machine.states["Fall"].jump()
		state_machine.change_state("Fall")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	if not $"../..".is_on_floor():
		state_machine.change_state("Fall")
	
	if Input.is_action_just_pressed("jump") and $"../..".is_on_floor():
		state_machine.states["Fall"].jump()
		state_machine.change_state("Fall")
