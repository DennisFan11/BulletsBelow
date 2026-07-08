class_name DialogBaseBackground
extends TextureRect

func setup_texture(tex: Texture2D) -> void:
	texture = tex
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	anchor_right = 1.0
	anchor_bottom = 1.0
	grow_horizontal = Control.GROW_DIRECTION_BOTH
	grow_vertical = Control.GROW_DIRECTION_BOTH
