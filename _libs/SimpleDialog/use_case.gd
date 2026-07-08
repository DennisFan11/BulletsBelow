extends Node


class DialogManager:
	func Save()-> String: return ""
	func Load(s): pass
class DialogBuilder:
	## 內部使用tr()翻譯 
	## 快速導出所有文本以供翻譯
	func get_all_text_csv():pass

class BackEX: # Background
	func _init(arg):
		pass
class CharEX: # Character
	enum POS{CENTER}
	enum DISTANCE{FOREGROUND, MIDGROUND, BACKGROUND}
	func _init(arg):
		pass
class IfEX: # 分支 tag必須確保回朔場景完整性
	func _init(text, tag=null, fun=null):
		pass



## 自動注入
var _dialog_manager: DialogManager
func  _ready():
	## 建立角色
	var charA = CharEX.new("Alice")
	
	var data = DialogBuilder.new()\
		.set_back(BackEX.new(preload("res://background.png")))\
		.add_char(charA)\
		.who(charA).say("你好。").end()\
		.who(charA).say("你好。").end()\
		.who(charA).say("你好。").end()\
		.who(charA).say("你好。").end()\
		.who(charA).move(CharEX.POS.CENTER).distance(CharEX.DISTANCE.FOREGROUND).say("特寫鏡頭！").end()\
		.who(charA).distance(CharEX.DISTANCE.BACKGROUND).say("遠景鏡頭...").tag("t1").end()\
		.who(charA).say("你好。").tag("t2").end()\
		.branch([
			IfEX.new("RouteA", "t1", func():pass),
			IfEX.new("RouteB", "t2"),
			IfEX.new("RouteC", "t3"),
			IfEX.new("RouteD")
			])\
		.remove_char(charA).end()\
		.clear_all().tag("t3").end()\
		.set_back(BackEX.new(preload("res://background.png")))\
		.add_char(charA).end()
	
	
	await _dialog_manager.play( ## play 中途可開啟 history回朔 且必須確保回朔場景完整性
		data
	)
