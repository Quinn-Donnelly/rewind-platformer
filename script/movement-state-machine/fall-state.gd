extends State
class_name Fall

var bufferedJump: bool = true
var initial_height: float
const JUMP_VELOCITY = -500.0
const MAX_JUMP_HEIGHT: float = 130.0

func enter(previous_state: State) -> void:
	bufferedJump = false

func _physics_process(delta: float) -> void:
	if $"../..".is_on_floor():
		state_machine.change_state("Idle")
		return
	
	var remaining_height = $"../..".position.y -  (initial_height - MAX_JUMP_HEIGHT)
	if remaining_height <= 0:
		$"../..".velocity.y *= -2.5

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		$JumpBufferTimer.start()
		bufferedJump = true

func _on_fall_timer_timeout() -> void:
	bufferedJump = false

func jump() -> void:
	initial_height = $"../..".position.y
	$"../..".velocity.y = JUMP_VELOCITY
