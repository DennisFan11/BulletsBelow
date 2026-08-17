class_name Player
extends Node2D

@export var character_body_2d: CharacterBody2D
@export var bot_body: BotBody

func _ready() -> void:
	DI.register("_player", self)
	
	
	_test()
	
func _test():
	var weapon := preload("res://GameSystem/WeaponSystem/手槍/手槍.tscn").instantiate()
	## 清理舊武器
	if is_instance_valid(bot_body.weapon):
		bot_body.weapon.queue_free()
	
	bot_body.add_child(weapon)
	bot_body.weapon = weapon








## 玩家移動
@export var move_speed: float = 500.0
func _physics_process(_delta: float) -> void:
	var move_dir := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	character_body_2d.velocity = move_dir * move_speed
	character_body_2d.move_and_slide()
	bot_body.正在移動  = move_dir != Vector2.ZERO

## 玩家瞄準
func _process(delta: float) -> void:
	bot_body.aim_global = get_global_mouse_position()


func get_player_global_pos()-> Vector2:
	if not is_node_ready(): return Vector2.ZERO
	return character_body_2d.global_position





##
