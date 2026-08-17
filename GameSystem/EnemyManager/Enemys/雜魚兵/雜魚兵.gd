class_name 雜魚兵
extends EnemyBase


@export var bot_body: BotBody


func  _ready() -> void: 
	var weapon: WeaponBase = preload("res://GameSystem/WeaponSystem/手槍/手槍.tscn").instantiate()
	weapon.team = LayerConfig.TEAM.ENEMY
	bot_body.add_weapon(weapon)

var _change_aim_cd: CooldownTimer = CooldownTimer.new()
func _process(delta: float) -> void:
	super(delta) ## 移動邏輯
	
	## BOT 適配邏輯
	#### 東張西望
	if not enemy_vision.can_see_player():
		if _change_aim_cd.is_ready():
			_change_aim_cd.trigger(1.5)
			bot_body.aim_global = global_position + Vector2.from_angle(randf_range(0.0, 2.0*PI))* randf_range(100.0, 500.0)
	#### 腳步
	bot_body.正在移動 = character_body_2d.velocity != Vector2.ZERO


const ATTACK_CD := 3.0
var _cd: CooldownTimer = CooldownTimer.new()

func _fire():
	bot_body.aim_global = _player.get_player_global_pos()
	if not _cd.is_ready():
		return
	_cd.trigger(ATTACK_CD)
	bot_body.weapon.fire()
	





##
