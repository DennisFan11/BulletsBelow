# res://asset/Libs/dialog/DialogConfig.gd
class_name DialogConfig
extends RefCounted

# 打字機效果每秒顯示字數
static var text_speed: float = 30.0

# 角色立繪全域佈局比例 (Anchor)
static var char_anchor_top: float = 0.3
static var char_anchor_bottom: float = 1.5
static var char_anchor_width: float = 0.5

# 角色距離設定 (特寫、標準、遠景)
static var distance_foreground_scale: Vector2 = Vector2(1.6, 1.6)
static var distance_foreground_modulate: Color = Color.WHITE

static var distance_midground_scale: Vector2 = Vector2(1.3, 1.3)
static var distance_midground_modulate: Color = Color.WHITE

static var distance_background_scale: Vector2 = Vector2(1.0, 1.0)
static var distance_background_modulate: Color = Color(0.7, 0.7, 0.7, 1.0)
