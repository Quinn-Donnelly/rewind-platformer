extends Node2D

class_name Level

signal level_entered


func _on_level_boundary_body_entered(body: Node2D) -> void:
	level_entered.emit(self)

func getCameraPosition() -> Vector2:
	return $CameraPosition.global_position
