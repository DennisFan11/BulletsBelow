class_name FactoryScene
extends Node


var _dialog_manager: DialogManager

func _ready() -> void:
	
	await get_tree().create_timer(0.1).timeout # 稍等 UI 初始化
	DI.injection(self, true)
	
const BOSS_TEXTURE := preload("uid://culw4yst17ks")
const BACK_GROUND := preload("uid://deg1s7r53kmh8")
const PLAYER_NAME_LIST := ["林子晴", "陳宇軒", "張以諾"]
