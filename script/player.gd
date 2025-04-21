extends CharacterBody2D
const RingQueue = preload("res://script/ring_queue.gd")

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const FALLING_IMPULSE = -10.0
const REWIND_SIZE = 5
var previous_positions: RingQueue

@export var marker: PackedScene
@export var throwable: PackedScene
@export var THROWABLE_IMPULSE = 1000
var throwable_information: RingQueue
@export var MAX_THROWABLE = 1

func _init() -> void:
	previous_positions = RingQueue.new()
	previous_positions.init(REWIND_SIZE)
	throwable_information = RingQueue.new()
	throwable_information.init(MAX_THROWABLE)
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		var gravity = get_gravity()
		gravity.y += FALLING_IMPULSE
		velocity += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("rewind"):
		var new_position = previous_positions.pop()
		if new_position != null:
			position = new_position

	if Input.is_action_just_pressed("throw"):
		var item = throwable.instantiate()
		item.position = $ThrowableLocation.global_position
		var direction = Vector2.RIGHT
		item.linear_velocity = direction * THROWABLE_IMPULSE
		throwable_information.add_item(item)
		get_parent().add_child(item)

	if Input.is_action_just_pressed("teleport"):
		var throwable_item = throwable_information.pop()
		if throwable_item != null:
			var new_position = throwable_item.global_position
			new_position.y -= 30
			position = new_position

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_rewind_capture_timer_timeout() -> void: 
	previous_positions.add_item(position)
	var mark = marker.instantiate()
	mark.position = position
	get_parent().add_child(mark)
