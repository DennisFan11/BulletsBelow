extends BaseBullet

@export var 一般子彈: Sprite2D

func _ready() -> void:
	if _team == LayerConfig.TEAM.PLAYER :
		一般子彈.texture = preload("uid://cj472a4rds6gp") 
	else:
		一般子彈.texture = preload("uid://d2l7cmmiu4llr")
	
