class_name Player
extends Node2D

### NOTE PUBLIC
## 玩家位置
func get_player_global_pos() -> Vector2:
	if not is_node_ready():
		return Vector2.ZERO

	return character_body_2d.global_position


## NOTE PRIVATE
@export var hurtbox: HurtBox

@export var character_body_2d: CharacterBody2D
@export var bot_body: BotBody


func _ready() -> void:
	DI.register("_player", self)
	_test()


func _test() -> void:
	var weapon := preload("res://GameSystem/WeaponSystem/手槍/手槍.tscn").instantiate()
	bot_body.add_weapon(weapon)
	







func _process(_delta: float) -> void:
	_aim(_delta)
	_fire()








## 玩家移動
@export var move_speed: float = 600.0
@export var acceleration: float = 7000.0
@export var deceleration: float = 10000.0

func _physics_process(delta: float) -> void:
	var move_dir := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	var target_velocity := move_dir * move_speed

	if move_dir != Vector2.ZERO:
		character_body_2d.velocity = character_body_2d.velocity.move_toward(
			target_velocity,
			acceleration * delta
		)
	else:
		character_body_2d.velocity = character_body_2d.velocity.move_toward(
			Vector2.ZERO,
			deceleration * delta
		)

	character_body_2d.move_and_slide()
	bot_body.正在移動 = character_body_2d.velocity.length() > 10.0




## 玩家瞄準
func _aim(_dt: float)-> void:
	bot_body.aim_global = get_global_mouse_position()

## 玩家射擊
func _fire()-> void:
	
	if not Input.is_action_pressed("fire"):
		return
	if not is_instance_valid(bot_body.weapon):
		return 
	bot_body.weapon.fire()
	
	






## 玩家受傷
@export var MAX_HP: float = 100.0
var _hp: float = MAX_HP
func take_hit(damage: float):
	_hp -= damage
	if _hp <= 0.0:
		hurtbox.queue_free()
		character_body_2d.queue_free()

## TODO 玩家死亡 & 重生






##
