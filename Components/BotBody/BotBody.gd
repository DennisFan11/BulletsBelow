@tool
class_name BotBody
extends Node2D




@export var 左腳: Sprite2D
@export var 右腳: Sprite2D
@export var body: Sprite2D
@export var eye_frame: Sprite2D
@export var eye_shader: ColorRect


func _process(dt: float) -> void:
	_move(dt)
	_weapon_rot()
	_eye_move(dt)
	
	if Engine.is_editor_hint(): 
		aim_global = get_global_mouse_position()



## 武器動畫
@export var 武器動畫: bool = false
@export var aim_global: Vector2
@export var weapon: WeaponBase

func _weapon_rot():
	if not weapon: return
	if not 武器動畫: return 
	const WEAPON_DIST = 10.0
	var global_aim_vec := aim_global- global_position
	weapon.position = global_aim_vec.normalized() * WEAPON_DIST
	weapon.global_rotation = global_aim_vec.angle()
	
	weapon.flip = global_aim_vec.dot(Vector2.LEFT) > 0.0
		
	
	
## 眼睛動畫
const EYE_DIST: float = 0.3
const VIEW_R: float = 500.0

var _drag_pos: Vector2 = Vector2.ZERO
const FOLLOW_SPEED: float = 5.0
func _eye_move(dt: float):
	var target_vec := aim_global- global_position
	var target_offset := clampf(target_vec.length()/VIEW_R, 0.0, EYE_DIST)
	var target := target_vec.normalized() * target_offset
	_drag_pos = _drag_pos.lerp(target, dt * FOLLOW_SPEED)
	
	var mat := (eye_shader.material as ShaderMaterial)
	mat.set_shader_parameter("pos_a", target)
	mat.set_shader_parameter("pos_b", _drag_pos)






## 移動動畫
@export var 正在移動: bool = true
@export var 左右腳交替間隔: float = 0.7
@export var 交替曲線: Curve

func _move(dt: float) -> void:
	if 正在移動:
		var time: float = CooldownTimer.get_ticks_sec()
		var progressL: float = fmod(time, 左右腳交替間隔)/ 左右腳交替間隔
		var progressR: float = fmod(time+左右腳交替間隔*0.5, 左右腳交替間隔)/ 左右腳交替間隔

		左腳.modulate.a = 交替曲線.sample_baked(progressL)
		右腳.modulate.a = 交替曲線.sample_baked(progressR)
	else:
		左腳.modulate.a = 1.0
		右腳.modulate.a = 1.0






##
