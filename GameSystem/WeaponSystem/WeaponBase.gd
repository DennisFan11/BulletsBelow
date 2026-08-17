@tool
class_name WeaponBase
extends Node2D

var _bullet_manager: BulletManager

## PUBLIC

@export var team: LayerConfig.TEAM

@export var flip: bool = false:
	set(new):
		flip = new
		scale = Vector2(1.0, -1.0 if flip else 1.0)


## TODO 射擊煙霧
## TODO 射擊槍口火光
## TODO 射擊螢幕震動
## TODO 射擊音效
## TODO 高速射擊

@export var FIRE_CD: float = 0.4
var _fire_cd: CooldownTimer = CooldownTimer.new()
func fire():
	if not _fire_cd.is_ready():
		return
	_fire_cd.trigger(FIRE_CD)
	_fire()
	

func _fire():
	_bullet_manager.create(
		BulletManager.TYPE.NORMAL_BULLET,
		_get_fire_pos(),
		750.0 * _get_fire_angle(),
		team
	)




## PRIVATE



## 輔助函數
func _get_fire_pos()-> Vector2:
	return %FireMarker.global_position
func _get_fire_angle()-> Vector2:
	return (_get_fire_pos()-global_position).normalized()

@export var r_hand: Sprite2D
@export var l_hand: Sprite2D


func _process(_delta: float) -> void:
	r_hand.global_rotation = 0.0
	l_hand.global_rotation = 0.0
