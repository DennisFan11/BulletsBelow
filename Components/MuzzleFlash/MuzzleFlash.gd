class_name MuzzleFlash
extends Node2D


func _ready() -> void:
	%FlashSprite.scale = Vector2.ZERO
	%FireLight2D.energy = 0.0


func flash(duration: float) -> void:
	var tween := get_tree().create_tween()
	tween.set_ignore_time_scale(true)

	%FlashSprite.scale = Vector2.ONE * randf_range(1.0, 1.5)
	tween.tween_property(%FlashSprite, "scale", Vector2.ZERO, duration)

	%FireLight2D.energy = randf_range(0.5, 3.0)
	tween.parallel().tween_property(%FireLight2D, "energy", 0.0, duration)
