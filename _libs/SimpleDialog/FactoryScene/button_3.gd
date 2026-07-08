extends Button
class_name DialogStep3_Algorithm

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
	.who(boss).say("很好，既然完美的配比已經算出來了，現在我們要把它轉化為實際的設計。").end() \
	.who(boss).move(CharEX.POS.CENTER).end() \
	.who(boss).say("%s，你們現在要依據這個配比，來規劃輸送帶的走向與分流邏輯。" % player_names_str).end() \
	.who(boss).say("為了應付龐大的產能，請務必運用平行處理的概念，設計出多條能平行運作的模組化產線！").end() \
	.who(boss).say("把產線演算法的設計圖畫出來吧！").end() \
	.clear_all().end()
	
	print("開始播放對話：第三階段 - 建立演算法")
	await _dialog_manager.play(data)
	print("第三階段對話結束！")
