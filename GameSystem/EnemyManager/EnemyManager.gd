class_name EnemyManager
extends Node2D






enum TYPE {ZAKO}
var _scene_map: Dictionary[EnemyManager.TYPE, PackedScene] = {
	EnemyManager.TYPE.ZAKO: preload("uid://colgemkwuy50k")
}
func _ready() -> void:
	DI.register("_enemy_manager", self)
	
	_test_spawn()

func _test_spawn():
	await get_tree().create_timer(2.0).timeout
	create(TYPE.ZAKO, Vector2.ZERO)

## TODO 敵人生成特效
func create(type: TYPE, pos:Vector2):
	var enemy: EnemyBase = _scene_map[type].instantiate()
	enemy.global_position = pos
	add_child(enemy)
	
	
	
	
	
