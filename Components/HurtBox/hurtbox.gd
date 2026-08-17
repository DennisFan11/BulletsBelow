class_name HurtBox
extends Area2D


@export var team: LayerConfig.TEAM
signal hit(damage: float)

func take_hit(damage: float):
	hit.emit(damage)

func _ready() -> void:
	## 掃描敵人
	collision_layer = LayerConfig.scan_self(team)
	collision_mask = LayerConfig.scan_self(team)
