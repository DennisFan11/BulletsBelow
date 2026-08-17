class_name BaseBullet
extends Node2D

@export
var DAMAGE: float = 20.0

@export var hitbox: Hitbox


## 初始資料
var _fire_pos: Vector2
var _init_vel: Vector2
## TODO 敵人子彈顏色區別(low)
var _team: LayerConfig.TEAM 

## 出生方法 由 BulletManager 調用
func on_create(pos: Vector2, vel: Vector2, team: LayerConfig.TEAM):
	_fire_pos = pos
	_init_vel = vel
	_team = team
	hitbox.team = _team
	global_position = pos
	global_rotation = vel.angle()



## TODO 子彈發光
## TODO 子彈擾動煙霧
func _process(delta: float) -> void:
	global_position += delta * _init_vel



## TODO 銷毀特效
## 撞牆立即銷毀
func _on_hitbox_hit_wall(_target_obj: BaseWall) -> void:
	queue_free()
	
## 撞到敵人
func _on_hitbox_on_hit(target_obj: HurtBox) -> void:
	assert(not target_obj.team == _team, "子彈撞到同隊")
	target_obj.take_hit(DAMAGE)
	queue_free()
