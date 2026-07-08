extends Button
class_name DialogStep4_Automation

var _dialog_manager: DialogManager

func _ready():
	pressed.connect(func():
		%UI.visible = false
		await start_dialog()
		%UI.visible = true
	)

func start_dialog():
	var boss = CharEX.new("老闆", FactoryScene.BOSS_TEXTURE)
	var player_names_str = "、".join(FactoryScene.PLAYER_NAME_LIST)
	
	var data = DialogBuilder.new() \
	.set_back(BackEX.new(FactoryScene.BACK_GROUND)) \
	.add_char(boss) \
	.who(boss).say("設計圖看起來非常完美，接下來就進入實作與模擬階段了。").end() \
	.who(boss).move(CharEX.POS.RIGHT).end() \
	.who(boss).say("%s，請依據你們剛剛的規劃，在廠區建置實際的生產線配置。" % player_names_str).end() \
	.who(boss).say("所有機台和輸送帶都放好之後，就按下啟動按鈕。").end() \
	.who(boss).say("讓我們看看這條產線能不能順利地自動運行！").end() \
	.clear_all().end()
	
	print("開始播放對話：第四階段 - 自動化")
	await _dialog_manager.play(data)
	print("第四階段對話結束！")
