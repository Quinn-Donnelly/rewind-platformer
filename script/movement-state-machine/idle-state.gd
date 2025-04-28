extends State
class_name Idle

const JUMP_VELOCITY = -500.0

func enter(previous_state: State) -> void:
	if previous_state is Fall and previous_state.bufferedJump:
		$"../..".velocity.y = JUMP_VELOCITY
		state_machine.change_state("Fall")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	if not $"../..".is_on_floor():
		state_machine.change_state("Fall")
	
	if Input.is_action_just_pressed("jump") and $"../..".is_on_floor():
		$"../..".velocity.y = JUMP_VELOCITY
		state_machine.change_state("Fall")
