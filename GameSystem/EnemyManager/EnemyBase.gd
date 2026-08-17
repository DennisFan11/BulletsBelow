class_name EnemyBase
extends Node2D




@export var hurt_box: HurtBox


@export var enemy_vision: EnemyVision



@export var character_body_2d: CharacterBody2D


@export var move_speed: float = 100.0

var _wander_dir := Vector2.ZERO
var _wander_time := 0.0



## PUBLIC
@export var MAX_HP: float = 100.0
var _hp: float = MAX_HP

func take_hit(damage: float):
	_hp -= damage
	if _hp <= 0.0:
		hurt_box.queue_free()
		queue_free()
## TODO 擊中敵人音效


var _player: Player

## PRIVATE
func _process(delta: float) -> void:

	if enemy_vision.can_see_player():
		var player_pos := _player.get_player_global_pos()
		var dir := global_position.direction_to(player_pos)
		var distance := global_position.distance_to(player_pos)

		## 戰鬥移動
		_wander_time -= delta

		if _wander_time <= 0.0:
			_wander_time = randf_range(1.0, 3.0)

			if randf() < 0.5:
				_wander_dir = dir.rotated(PI / 2.0)
			else:
				_wander_dir = dir.rotated(-PI / 2.0)


		## 太遠：斜著靠近
		if distance > 500.0:
			character_body_2d.velocity = (
				dir + _wander_dir
			).normalized() * move_speed

		## 太近：斜著後退
		elif distance < 250.0:
			character_body_2d.velocity = (
				-dir + _wander_dir
			).normalized() * move_speed

		## 距離正常：左右繞
		else:
			character_body_2d.velocity = _wander_dir * move_speed


		## 射擊
		_fire()

	else:
		## 隨機遊走
		_wander_time -= delta

		if _wander_time <= 0.0:
			_wander_time = randf_range(1.0, 3.0)
			_wander_dir = Vector2.from_angle(
				randf_range(0.0, TAU)
			)

		character_body_2d.velocity = _wander_dir * move_speed

	character_body_2d.move_and_slide()


## NOTE 需要複寫
func _fire():
	pass


##
