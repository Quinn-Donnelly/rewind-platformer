extends State
class_name Fall

var bufferedJump: bool = true
var initial_height: float
const JUMP_VELOCITY = -400.0
var is_holding_jump: bool = false
var frames_held: float = 0
const MAX_JUMP_HEIGHT: float = 150
const MAX_JUMP_HOLD: float = 0.35
const MIN_JUMP_HOLD: float = 0.25;

func enter(previous_state: State) -> void:
	bufferedJump = false

func _physics_process(delta: float) -> void:
	
	if $"../..".is_on_floor():
		state_machine.change_state("Idle")
		return
	
	if is_holding_jump:
		frames_held += delta
		if Input.is_action_pressed("jump") and frames_held < MAX_JUMP_HOLD:
			$"../..".velocity.y = JUMP_VELOCITY
		elif frames_held < MIN_JUMP_HOLD:
			$"../..".velocity.y = JUMP_VELOCITY
		else:
			print("Jump held for: %s" % frames_held)
			is_holding_jump = false
			if frames_held < MAX_JUMP_HOLD:
				$"../..".velocity.y *= -0.5
		
	
	if frames_held >= MAX_JUMP_HOLD:
		var remaining_height = $"../..".position.y -  (initial_height - MAX_JUMP_HEIGHT)
		if remaining_height <= 0:
			$"../..".velocity.y *= -0.5

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		$JumpBufferTimer.start()
		bufferedJump = true

func _on_fall_timer_timeout() -> void:
	bufferedJump = false

func jump() -> void:
	initial_height = $"../..".position.y
	$"../..".velocity.y = JUMP_VELOCITY
	is_holding_jump = true

func exit(next_state: State) -> void:
	frames_held = 0
	is_holding_jump = false
