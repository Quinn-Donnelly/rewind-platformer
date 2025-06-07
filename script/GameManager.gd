extends Node

signal win

var score: int = 0 
var is_game_over: bool = false
var stage_time: int = 0

func _ready() -> void:
	$Camera/UI/RestartLabel.visible = false
	$Camera/UI/GameOverLabel.visible = false
	start_game()

func start_game() -> void:
	stage_time = Time.get_ticks_msec()
	is_game_over = false
	score = 0

func game_over() -> void:
	is_game_over = true
	$Camera/UI/GameOverLabel.visible = true

func win_game() -> void:
	# TODO: refactor stage_time name
	var duration = Time.get_ticks_msec() - stage_time
	var expected_time = 10000.0
	var stage_time_expected_points = 100.0
	var time_score = stage_time_expected_points * (expected_time / float(duration))
	addScore(time_score)
	
	win.emit()
	is_game_over = true
	$Player.set_process(false)
	$Player.set_physics_process(false)
	$Camera/UI/WinLabel.visible = true
	$Camera/UI/RespawnDelayTimer.start()

func _on_player_death() -> void:
	game_over()
	$Camera/UI/RespawnDelayTimer.start()


func _on_respawn_delay_timer_timeout() -> void:
	$Camera/UI/RestartLabel.visible = true

func _input(event: InputEvent) -> void:
	if is_game_over and Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func _on_win_flag_win() -> void:
	win_game()

func addScore(amount: int) -> int:
	score += amount
	$Camera/UI/ScoreLabel.text = "Score: %d" % score
	return score
