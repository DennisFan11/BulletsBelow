class_name BaseWall
extends StaticBody2D





## TODO 牆壁斜陰影




func _ready() -> void:
	collision_layer |= LayerConfig.scan_wall()
	collision_mask |= LayerConfig.scan_wall()













##
