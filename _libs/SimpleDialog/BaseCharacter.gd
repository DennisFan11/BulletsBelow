class_name DialogBaseCharacter
extends TextureRect

func _ready() -> void:
	pass

func setup_texture(tex: Texture2D) -> void:
	texture = tex
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	# 預設位置 (LEFT)
	anchor_top = DialogConfig.char_anchor_top
	anchor_bottom = DialogConfig.char_anchor_bottom
	anchor_left = 0.0
	anchor_right = DialogConfig.char_anchor_width
	mouse_filter = Control.MOUSE_FILTER_IGNORE
