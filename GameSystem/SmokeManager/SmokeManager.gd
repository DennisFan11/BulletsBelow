class_name SmokeManager
extends Node2D


func _ready() -> void:
	DI.register("_smoke_manager", self)


func create(pos: Vector2, angle: float = 0.0, late_join: bool = false) -> Smoke:
	var smoke := SmokeDB.get_scene().instantiate() as Smoke
	smoke.global_position = pos
	smoke.rotation = angle

	if late_join:
		%SmokeGroup.call_deferred("add_child", smoke)
	else:
		%SmokeGroup.add_child(smoke)

	return smoke
