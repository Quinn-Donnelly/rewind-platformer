extends State
class_name Fall

var bufferedJump: bool = true

func enter(previous_state: State) -> void:
	bufferedJump = false

func _physics_process(delta: float) -> void:
	if $"../..".is_on_floor():
		state_machine.change_state("Idle")

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		$JumpBufferTimer.start()
		bufferedJump = true

func _on_fall_timer_timeout() -> void:
	bufferedJump = false
