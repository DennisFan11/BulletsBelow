extends Node

const DialogManagerScene = preload("res://asset/Libs/dialog/Manager/DialogManager.tscn")

func _ready() -> void:
	# 模擬專案的 DI 行為：動態產生 DialogManager 並加入 SceneTree
	var manager: DialogManager = DialogManagerScene.instantiate()
	add_child(manager)
	
	await get_tree().create_timer(0.1).timeout # 稍等 UI 初始化
	
	# 執行原版的 use_case.gd 測試指令
	# 這裡套用了已有的 ShopChar.png 測試圖片
	var charA = CharEX.new("Shopkeeper", preload("uid://dh1yj1mhgae78"))
	
	var data = DialogBuilder.new() \
		.set_back(BackEX.new("")) \
		.add_char(charA) \
		.who(charA).say("你好，歡迎來到 Godot 對話系統外掛測試。").end() \
		.who(charA).say("現在我將走到畫面正中間。").end() \
		.who(charA).move(CharEX.POS.CENTER).end() \
		.who(charA).say("你可以隨時開啟右上角的 History 回朔過去的對話。").tag("t1").end() \
		.who(charA).say("現在請做出選擇：").tag("t2").end() \
		.branch([
			IfEX.new("請再講一次剛剛說的", "t1", func(): print("Player selected Route A")),
			IfEX.new("可以了，結束吧", "t5",  func(): print("Player selected End")),
			IfEX.new("其他", "t3")
		]) \
		.exit().end()\
		.remove_char(charA).end() \
		.clear_all().end()\
		
		.set_back(BackEX.new("")).tag("t3") \
		.add_char(charA) \
		.who(charA).say("這裡是 Route3 我又回來了").end()\
		.who(charA).move(CharEX.POS.RIGHT).end()\
		.who(charA).say("永遠不會結束了    .    .    .").end()\
		.who(charA).move(CharEX.POS.LEFT).end()\
		.branch([IfEX.new("??????", "t3")])\
		
		.exit().tag("t5").end()
	
	print("開始播放對話...")
	await manager.play(data)
	print("對話結束播放！")
