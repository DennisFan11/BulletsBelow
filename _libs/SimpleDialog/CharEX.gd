# res://dialog_system/char_ex.gd
class_name CharEX

enum POS { LEFT, CENTER, RIGHT }
enum DISTANCE { FOREGROUND, MIDGROUND, BACKGROUND }

var char_name: String
var texture_path: String = ""
var position: POS = POS.LEFT
var distance: DISTANCE = DISTANCE.MIDGROUND
var expression: String = "default"
var visible: bool = false

# 支援直接傳入 String 或 preload() 回傳的 Resource
func _init(name: String, res: Variant = null) -> void:
	char_name = name
	if typeof(res) == TYPE_STRING:
		texture_path = res
	elif res is Resource:
		texture_path = res.resource_path

## 產生可序列化快照
func snapshot() -> Dictionary:
	return {
		"char_name":    char_name,
		"texture_path": texture_path,
		"position":     int(position),
		"distance":     int(distance),
		"expression":   expression,
		"visible":      visible,
	}
