class_name Hitbox
extends Area2D

## 用以偵測 HurtBox 和牆


signal on_hit(target_obj: HurtBox)
signal hit_wall(target_obj: BaseWall)

@export var team: LayerConfig.TEAM


func _ready() -> void:
	## 掃描 敵人&牆
	collision_layer = LayerConfig.scan_enemy(team) | LayerConfig.scan_wall()
	collision_mask = LayerConfig.scan_enemy(team) | LayerConfig.scan_wall()
	
	area_entered.connect( ## area 碰撞就是hurtbox
		(func (area):
			if area is HurtBox:
				on_hit.emit(area))
	)
	body_entered.connect( ## body碰撞就是 Wall
		(func (body):
			if body is BaseWall:
				hit_wall.emit(body))
	)

	






##
