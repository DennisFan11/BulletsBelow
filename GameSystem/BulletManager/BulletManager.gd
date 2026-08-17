class_name BulletManager
extends Node2D


func _ready() -> void:
	DI.register("_bullet_manager", self)





enum TYPE{
	NORMAL_BULLET, SHUTGUN_BULLET, RIFLE_BULLET,
	EYEMY_BULLET
}

var _scene_map:Dictionary[BulletManager.TYPE, PackedScene]= {
	TYPE.NORMAL_BULLET: preload("uid://c8u06ascod1sj")
}



## TODO 傷害倍率設定 low
func create(type: TYPE, pos: Vector2, vel: Vector2, team: LayerConfig.TEAM):
	var bullet: BaseBullet = _scene_map[type].instantiate()
	bullet.on_create(pos, vel, team)
	add_child(bullet)
	
	
	
	
	




##
