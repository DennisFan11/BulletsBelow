# res://dialog_system/back_ex.gd
class_name BackEX

var resource_path: String = ""

# 支援直接傳入 String 或 preload() 回傳的 Resource
func _init(res: Variant = null) -> void:
	if typeof(res) == TYPE_STRING:
		resource_path = res
	elif res is Resource:
		resource_path = res.resource_path
