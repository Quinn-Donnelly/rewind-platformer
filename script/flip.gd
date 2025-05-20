extends Node

@export_node_path("Sprite2D")
var sprite_path: NodePath
var sprite: Sprite2D

	
func setup(s_path: NodePath, shouldFlip: bool):
	sprite_path = s_path	
	if not sprite_path:
		push_error("Set sprite path for flip script")
	
	sprite = get_node(sprite_path)
	flip(shouldFlip)

func flip(shouldFlip: bool):
	sprite.flip_h = shouldFlip
