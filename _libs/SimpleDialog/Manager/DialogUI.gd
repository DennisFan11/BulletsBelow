# res://asset/Libs/dialog/Manager/DialogUI.gd
class_name DialogUI
extends CanvasLayer

@onready var manager: DialogManager = $".."

@onready var backgrounds_container: Control = $Backgrounds
@onready var portraits_container: Control = $Portraits
@onready var message_panel: Panel = $MessagePanel
@onready var name_label: Label = $MessagePanel/NameLabel
@onready var text_label: RichTextLabel = $MessagePanel/TextLabel
@onready var branch_container: VBoxContainer = $BranchContainer
@onready var history_panel: Panel = $HistoryPanel
@onready var history_list: VBoxContainer = $HistoryPanel/ScrollContainer/VBoxContainer
@onready var history_btn: Button = $HistoryButton

var _portraits: Dictionary = {}  # { String_name: TextureRect }

var _is_typing: bool = false
var _typing_tween: Tween

func _ready() -> void:
	# 綁定 DialogManager 信號
	manager.say_requested.connect(_on_say_requested)
	manager.move_requested.connect(_on_move_requested)
	manager.distance_requested.connect(_on_distance_requested)
	manager.background_changed.connect(_on_background_changed)
	manager.char_added.connect(_on_char_added)
	manager.char_removed.connect(_on_char_removed)
	manager.scene_cleared.connect(_on_scene_cleared)
	manager.branch_requested.connect(_on_branch_requested)
	manager.dialog_finished.connect(_on_dialog_finished)
	
	if history_btn:
		history_btn.pressed.connect(_on_history_btn_pressed)
		history_btn.z_index = 10
		
	message_panel.focus_mode = Control.FOCUS_ALL
	message_panel.gui_input.connect(_on_message_panel_gui_input)
	message_panel.z_index = 10
	branch_container.z_index = 10
	history_panel.z_index = 10
	
	_clear_ui()

func _on_message_panel_gui_input(event: InputEvent) -> void:
	if not manager._is_playing or manager._wait_state != DialogManager.WaitState.INPUT:
		return
	
	# 若歷史紀錄面版開啟中，則不允許推進對話
	if history_panel.visible:
		return

	var is_advance = false
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		is_advance = true
	elif event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			is_advance = true
			
	if is_advance:
		message_panel.accept_event()
		if _is_typing:
			if _typing_tween:
				_typing_tween.kill()
			_is_typing = false
			text_label.visible_characters = -1
		else:
			manager.input_advanced.emit()

func _clear_ui() -> void:
	message_panel.hide()
	branch_container.hide()
	history_panel.hide()
	if history_btn:
		history_btn.hide()
	for child in backgrounds_container.get_children():
		child.queue_free()
	for child in portraits_container.get_children():
		child.queue_free()
	_portraits.clear()

# ── 外部信號處理 ──────────────────────────────────────────────

func _on_say_requested(who_name: String, text: String) -> void:
	message_panel.show()
	message_panel.grab_focus()
	branch_container.hide()
	if history_btn:
		history_btn.show()
	name_label.text = who_name
	text_label.text = text
	text_label.visible_characters = 0
	_is_typing = true
	
	if _typing_tween:
		_typing_tween.kill()
		
	var duration: float = text.length() / DialogConfig.text_speed
	_typing_tween = create_tween()
	_typing_tween.tween_property(text_label, "visible_characters", text.length(), duration).from(0)
	_typing_tween.finished.connect(func():
		_is_typing = false
		text_label.visible_characters = -1
	)

func _on_background_changed(path: String) -> void:
	for child in backgrounds_container.get_children():
		child.queue_free()
		
	if path == "": return
	
	var actual_path = path.replace("preload ", "").replace("res://", "")
	var res: Resource = null
	if ResourceLoader.exists("res://" + actual_path):
		res = load("res://" + actual_path)
	elif ResourceLoader.exists(path):
		res = load(path)
		
	if res == null: return
	
	if res is PackedScene:
		var scene = res.instantiate()
		backgrounds_container.add_child(scene)
	elif res is Texture2D:
		var bg_node = preload("res://asset/Libs/dialog/BaseBackground.tscn").instantiate()
		if bg_node.has_method("setup_texture"):
			bg_node.setup_texture(res)
		backgrounds_container.add_child(bg_node)

func _on_char_added(char_name: String, texture_path: String) -> void:
	if _portraits.has(char_name): return
	
	var char_node: Control = null
	var res: Resource = null
	
	if texture_path != "":
		if ResourceLoader.exists(texture_path):
			res = load(texture_path)
			
	if res is PackedScene:
		char_node = res.instantiate()
		char_node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		char_node = preload("res://asset/Libs/dialog/BaseCharacter.tscn").instantiate()
		if res is Texture2D and char_node.has_method("setup_texture"):
			char_node.setup_texture(res)
			
	# 動態控制其佔位，預設放置於左邊
	char_node.anchor_top = DialogConfig.char_anchor_top
	char_node.anchor_bottom = DialogConfig.char_anchor_bottom
	char_node.anchor_left = 0.0
	char_node.anchor_right = DialogConfig.char_anchor_width
	
	# 強制綁定 pivot_offset 更新，以圖片正中心為縮放點
	char_node.resized.connect(func():
		if is_instance_valid(char_node):
			char_node.pivot_offset = Vector2(char_node.size.x / 2.0, char_node.size.y / 2.0)
	)
	
	portraits_container.add_child(char_node)
	_portraits[char_name] = char_node

func _on_char_removed(char_name: String) -> void:
	if _portraits.has(char_name):
		var rect = _portraits[char_name]
		rect.queue_free()
		_portraits.erase(char_name)

func _on_move_requested(who_name: String, pos: int) -> void:
	if not _portraits.has(who_name): return
	var rect: Control = _portraits[who_name]
	var tw = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	
	var w = DialogConfig.char_anchor_width
	
	# 根據 CharEX.POS 即時排列畫面位置 (0:LEFT, 1:CENTER, 2:RIGHT)
	if pos == 0:
		tw.tween_property(rect, "anchor_left", 0.0, 0.3)
		tw.tween_property(rect, "anchor_right", w, 0.3)
	elif pos == 1:
		tw.tween_property(rect, "anchor_left", 0.5 - (w / 2.0), 0.3)
		tw.tween_property(rect, "anchor_right", 0.5 + (w / 2.0), 0.3)
	elif pos == 2:
		tw.tween_property(rect, "anchor_left", 1.0 - w, 0.3)
		tw.tween_property(rect, "anchor_right", 1.0, 0.3)

func _on_distance_requested(who_name: String, dist: int) -> void:
	if not _portraits.has(who_name): return
	var rect: Control = _portraits[who_name]
	var tw = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	
	var target_scale = Vector2.ONE
	var target_modulate = Color.WHITE
	var target_z_index = 0
	
	# 根據 CharEX.DISTANCE 設定
	if dist == 0: # FOREGROUND
		target_scale = DialogConfig.distance_foreground_scale
		target_modulate = DialogConfig.distance_foreground_modulate
		target_z_index = 2
	elif dist == 1: # MIDGROUND
		target_scale = DialogConfig.distance_midground_scale
		target_modulate = DialogConfig.distance_midground_modulate
		target_z_index = 1
	elif dist == 2: # BACKGROUND
		target_scale = DialogConfig.distance_background_scale
		target_modulate = DialogConfig.distance_background_modulate
		target_z_index = 0
		
	tw.tween_property(rect, "scale", target_scale, 0.3)
	tw.tween_property(rect, "modulate", target_modulate, 0.3)
	rect.z_index = target_z_index

func _on_branch_requested(choices: Array) -> void:
	# 隱藏一般對話，顯示選項
	message_panel.hide()
	branch_container.show()
	if history_btn:
		history_btn.show()
	
	# 清空舊按鈕
	for child in branch_container.get_children():
		child.queue_free()
		
	# 動態建立按鈕
	for i in choices.size():
		var choice: IfEX = choices[i]
		var btn = Button.new()
		btn.text = choice.display_text
		btn.custom_minimum_size = Vector2(300, 50)
		btn.pressed.connect(func(idx=i):
			branch_container.hide()
			manager.branch_selected.emit(idx)
		)
		branch_container.add_child(btn)

func _on_scene_cleared() -> void:
	for child in portraits_container.get_children():
		child.queue_free()
	_portraits.clear()
	for child in backgrounds_container.get_children():
		child.queue_free()

func _on_dialog_finished() -> void:
	_clear_ui()

# ── 歷史紀錄 ────────────────────────────────────────────────

func _on_history_btn_pressed() -> void:
	if history_panel.visible:
		history_panel.hide()
	else:
		_populate_history()
		history_panel.show()

func _populate_history() -> void:
	# 清空
	for child in history_list.get_children():
		child.queue_free()
		
	var count = manager.get_history_count()
	for i in count:
		var summary = manager.get_history_summary(i)
		if summary.is_empty(): continue
		if summary.preview == "": continue
		
		# 建立紀錄列表項
		var hbox = HBoxContainer.new()
		var lbl = Label.new()
		lbl.text = summary.preview
		lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		
		var re_btn = Button.new()
		re_btn.text = "⏪ 回朔至此"
		re_btn.pressed.connect(func(idx=i):
			history_panel.hide()
			manager.rewind_to(idx)
		)
		
		hbox.add_child(lbl)
		hbox.add_child(re_btn)
		history_list.add_child(hbox)
