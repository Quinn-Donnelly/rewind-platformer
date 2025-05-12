extends Node

signal win

var score: int = 0 
var is_game_over: bool = false

func _ready() -> void:
	score = 0
	$Camera/UI/RestartLabel.visible = false
	$Camera/UI/GameOverLabel.visible = false
	is_game_over = false

func game_over() -> void:
	is_game_over = true
	$Camera/UI/GameOverLabel.visible = true

func win_game() -> void:
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
