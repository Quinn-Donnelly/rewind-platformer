extends Node

signal win

var COLLECTABLE_SCORE_MULT = 5.0

var score: int = 0 
var is_game_over: bool = false
var stage_time: int = 0

func _ready() -> void:
	$Camera/UI/RestartLabel.visible = false
	$Camera/UI/GameOverLabel.visible = false
	$Camera/UI/ScoreBoard.visible = false
	start_game()
	win.connect($"/root/Score".submitScore)
	
func _process(delta: float) -> void:
	if not is_game_over:
		var time_in_secs = round((Time.get_ticks_msec() - stage_time) / 1000)
		$Camera/UI/GameTime.text = "Time: %s" % time_in_secs

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
	var expected_time = 10.0
	var stage_time_expected_points = 100.0
	var time_score = 0
	
	if duration < expected_time:
		time_score =  stage_time_expected_points * (2 - float(duration) / float(expected_time))
	else:
		time_score = stage_time_expected_points * (float(expected_time) / float(duration/1000))
	addScore(time_score)
	
	
	win.emit(score)
	is_game_over = true
	$Player.set_process(false)
	$Player.set_physics_process(false)
	$Camera/UI/WinLabel.visible = true
	$Camera/UI/RespawnDelayTimer.start();

func _on_player_death() -> void:
	game_over()
	$Camera/UI/RespawnDelayTimer.start()


func _on_respawn_delay_timer_timeout() -> void:
	$Camera/UI/ScoreBoard.visible = true
	$Camera/UI/RestartLabel.visible = true

func _input(event: InputEvent) -> void:
	if is_game_over and Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func _on_win_flag_win() -> void:
	win_game()

func addScore(amount: float) -> int:
	var amount_to_add = int(floor(amount))
	score += amount_to_add
	$Camera/UI/ScoreLabel.text = "Score: %d" % score
	return score


func _on_collectable_scored(points) -> void:
	addScore(points * COLLECTABLE_SCORE_MULT)
