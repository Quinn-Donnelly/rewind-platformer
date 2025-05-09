extends Node2D

func _ready() -> void:
	var levels = $"../Levels".get_children()
	for level in levels:
		(level as Level).level_entered.connect(_on_level_1_level_entered)

func _on_level_1_level_entered(level: Level) -> void:
	print("Moving levels: %s", level)
	set_deferred("position", level.getCameraPosition())
