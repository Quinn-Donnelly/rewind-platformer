extends Area2D

@export
var score: int

signal scored

func _ready() -> void:
	$ScoreLabel.text = "+%d" % score

func _on_body_entered(body: Node2D) -> void:
	if body is player:
		scored.emit(score)
		queue_free()
