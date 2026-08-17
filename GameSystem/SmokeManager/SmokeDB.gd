class_name SmokeDB
extends RefCounted


static var _scene: PackedScene = preload("res://GameSystem/SmokeManager/Smoke/Smoke.tscn")


static func get_scene() -> PackedScene:
	return _scene
