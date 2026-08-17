class_name TestNode
extends Node2D

func _ready() -> void:
	if not Engine.is_editor_hint(): 
		queue_free()
