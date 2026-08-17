class_name EnemyVision
extends Node2D


@export var R: float = 1500.0






var _player: Player


func can_see_player()-> bool:
	return (
		global_position - _player.get_player_global_pos()
		).length() < R





##
