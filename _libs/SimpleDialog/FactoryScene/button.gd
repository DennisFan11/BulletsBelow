extends Button
class_name DialogStep1_ProblemId

var _dialog_manager: DialogManager

func _ready():
	pressed.connect(func():
		%UI.visible = false
		await start_dialog()
		%UI.visible = true
	)

func start_dialog():
	var boss = CharEX.new("老闆", FactoryScene.BOSS_TEXTURE)
	# 將陣列轉換成以「、」分隔的字串
	var player_names_str = "、".join(FactoryScene.PLAYER_NAME_LIST) 
	player_names_str = "[color=red]" + player_names_str + "[/color]"
	var data = DialogBuilder.new() \
	.set_back(BackEX.new(FactoryScene.BACK_GROUND)) \
	.add_char(boss) \
	
	
	.who(boss).say("你們看看最近的市場報價！記憶體價格簡直是一飛衝天啊！").end() \
	
	.who(boss).say("這可是個大好機會，我決定了，我們的工廠要全面轉型。").end() \
	.who(boss).move(CharEX.POS.CENTER).end() \
	.who(boss).distance(CharEX.DISTANCE.FOREGROUND).end()\
	.who(boss).say("從今天起，我們開始製造記憶體！").end() \
	.who(boss).say("%s，你們身為工廠最頂尖的工程團隊，先去把記憶體的製造步驟和原料拆解出來，了解我們需要什麼。" % player_names_str).end() \
	.clear_all().end()
	
	print("開始播放對話：第一階段 - 問題識別")
	await _dialog_manager.play(data)
	print("第一階段對話結束！")
