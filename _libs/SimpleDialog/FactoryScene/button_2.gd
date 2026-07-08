extends Button
class_name DialogStep2_DataAnalysis

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
	.who(boss).say("這到底怎麼回事？！我看報表，工廠的整體效率怎麼這麼低！").end() \
	.who(boss).move(CharEX.POS.LEFT).end() \
	.who(boss).say("你們知道那些封裝機台有多貴嗎？竟然有一半都在空轉等料！").end() \
	.who(boss).say("%s，你們團隊打算怎麼解決這個問題？" % player_names_str).tag("q1").end() \
	.branch([
		IfEX.new("再買更多機台！", "wrong_answer", func(): print("Player selected wrong answer")),
		IfEX.new("分析生產速率，計算完美配比", "correct_answer", func(): print("Player selected correct answer"))
	]) \
	.who(boss).tag("wrong_answer").say("胡說八道！機台很貴！給我去算好比例再來！").end() \
	.clear_all().end().exit() \
	.who(boss).tag("correct_answer").say("沒錯！作為老闆，我希望讓每一台機台都能滿效率運轉。").end() \
	.who(boss).say("快去蒐集每台機器的生產資料，把這該死的比例給我算對！").end() \
	.clear_all().end().exit()
	
	print("開始播放對話：第二階段 - 資料蒐集與分析")
	await _dialog_manager.play(data)
	print("第二階段對話結束！")
