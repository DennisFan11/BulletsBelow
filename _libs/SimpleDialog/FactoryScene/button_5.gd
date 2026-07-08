extends Button
class_name DialogStep5_Debugging

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
	.who(boss).say("產線已經跑起來了，但身為工程師，現在還不是休息的時候！").end() \
	.who(boss).say("%s，仔細觀察產線運作，看看是否有出現生產瓶頸或原物料堵塞的情況。" % player_names_str).end() \
	.who(boss).say("如果發現異常，必須立刻進行調整與優化，這就是除錯的過程！").end() \
	.who(boss).say("...").end() \
	.who(boss).move(CharEX.POS.CENTER).end() \
	.who(boss).say("非常好，產線現在運作得非常流暢，完全滿足了我們的記憶體產量需求！").end() \
	.who(boss).say("最後一步，把這塊驗證有效的高效產線區塊，封裝成通用的藍圖吧。").end() \
	.who(boss).say("這樣我們在後續擴建廠區時，就能直接複製使用了。幹得好！").end() \
	.clear_all().tag("end_dialog").end()
	
	print("開始播放對話：第五階段 - 測試與除錯")
	await _dialog_manager.play(data)
	print("第五階段對話結束！")
