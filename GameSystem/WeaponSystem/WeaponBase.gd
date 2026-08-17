@tool
class_name WeaponBase
extends Node2D





@export
var flip: bool = false:
	set(new):
		flip = new
		scale = Vector2(1.0, -1.0 if flip else 1.0)



@export var r_hand: Sprite2D
@export var l_hand: Sprite2D


func _process(delta: float) -> void:
	r_hand.global_rotation = 0.0
	l_hand.global_rotation = 0.0
