# res://dialog_system/if_ex.gd
class_name IfEX

var display_text: String  ## 顯示給玩家的選項文字
var jump_tag: String       ## 跳轉目標 tag；空字串 = fall-through（繼續往下）
var callback: Callable     ## 選擇此路線後執行的 callback（可用於設定 flag 等）

func _init(text: String, tag: String = "", cb: Callable = Callable()) -> void:
	display_text = text
	jump_tag = tag
	callback = cb
