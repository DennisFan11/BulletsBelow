# res://dialog_system/dialog_manager.gd
class_name DialogManager
extends Node

# ── Signals（UI 掛鉤）────────────────────────────────────────

signal say_requested(who_name: String, text: String)
signal move_requested(who_name: String, pos: int)   ## pos = CharEX.POS int 值
signal distance_requested(who_name: String, distance: int) ## distance = CharEX.DISTANCE int 值
signal background_changed(path: String)
signal char_added(char_name: String, texture_path: String)
signal char_removed(char_name: String)
signal scene_cleared()
signal branch_requested(choices: Array)             ## Array[IfEX]
signal dialog_finished()

## 由外部 UI 觸發，推進對話（玩家按確認鍵）
signal input_advanced()
## 由外部 UI 觸發，帶入選擇的 index
signal branch_selected(index: int)

# ── 內部狀態 ─────────────────────────────────────────────────

func _ready():
	DI.register("_dialog_manager", self)

var _nodes: Array = []
var _tag_table: Dictionary = {}
var _current_index: int = 0
var _history: Array = []        ## Array[SceneSnapshot]
var _branch_history: Array = [] ## Array[int]
var _scene_state: Dictionary = { "background": "", "characters": {} }
var _is_playing: bool = false

enum WaitState { NONE, INPUT, BRANCH }
var _wait_state: WaitState = WaitState.NONE
var _pending_rewind_index: int = -1

# ── Public API ───────────────────────────────────────────────

func play(builder: DialogBuilder) -> void:
	assert(not _is_playing, "DialogManager: play() 重複呼叫")
	builder.build()
	_nodes = builder._nodes
	_build_tag_table()
	_current_index  = 0
	_history.clear()
	_branch_history.clear()
	_scene_state    = { "background": "", "characters": {} }
	_is_playing     = true
	_wait_state     = WaitState.NONE
	_pending_rewind_index = -1
	await _execute_loop()
	_is_playing     = false
	dialog_finished.emit()

## 取得 history 快照數量（供 UI 顯示回朔列表）
func get_history_count() -> int:
	return _history.size()

## 取得第 i 個快照的摘要（供 UI 列表顯示）
func get_history_summary(i: int) -> Dictionary:
	if i < 0 or i >= _history.size():
		return {}
	var snap: SceneSnapshot = _history[i]
	var node: DialogNode    = _nodes[snap.node_index]
	var preview := ""
	if node is DialogNode.SayNode:
		preview = (node as DialogNode.SayNode).text
	return { "history_index": i, "node_index": snap.node_index, "preview": preview }

## 回朔到 history 第 i 步並還原場景（呼叫後繼續 play 的 await loop）
func rewind_to(history_index: int) -> void:
	if history_index < 0 or history_index >= _history.size():
		push_error("DialogManager: rewind_to index=%d 超出範圍" % history_index)
		return
	var snap: SceneSnapshot  = _history[history_index]
	_pending_rewind_index    = snap.node_index
	_scene_state             = snap.scene_state.duplicate(true)
	_branch_history          = snap.branch_history.duplicate()
	_history                 = _history.slice(0, history_index)
	_restore_scene()
	
	if _wait_state == WaitState.INPUT:
		input_advanced.emit()
	elif _wait_state == WaitState.BRANCH:
		branch_selected.emit(0)

## 序列化目前進度為 JSON 字串
func save() -> String:
	return JSON.stringify({
		"node_index":     _current_index,
		"scene_state":    _scene_state.duplicate(true),
		"branch_history": _branch_history.duplicate(),
	})

## 從 JSON 字串還原進度（場景自動重建）
func load(s: String) -> void:
	var data = JSON.parse_string(s)
	if not data is Dictionary:
		push_error("DialogManager: 無效的存檔資料")
		return
	_current_index  = data.get("node_index", 0)
	_scene_state    = data.get("scene_state", { "background": "", "characters": {} })
	_branch_history = data.get("branch_history", [])
	_restore_scene()

# ── Execution ────────────────────────────────────────────────

func _build_tag_table() -> void:
	_tag_table.clear()
	for i in _nodes.size():
		var n: DialogNode = _nodes[i]
		if n.tag != "":
			_tag_table[n.tag] = i

func _execute_loop() -> void:
	while _current_index < _nodes.size():
		if _pending_rewind_index != -1:
			_current_index = _pending_rewind_index
			_pending_rewind_index = -1
			
		_push_snapshot()
		await _execute_node(_nodes[_current_index])
		
		# 如果中途觸發了回朔，中止當前節點推進並開始新迴圈
		if _pending_rewind_index != -1:
			continue
			
		_current_index += 1

func _execute_node(node: DialogNode) -> void:
	if   node is DialogNode.SayNode:        await _exec_say(node)
	elif node is DialogNode.MoveNode:             _exec_move(node)
	elif node is DialogNode.DistanceNode:         _exec_distance(node)
	elif node is DialogNode.BackNode:             _exec_back(node)
	elif node is DialogNode.AddCharNode:          _exec_add_char(node)
	elif node is DialogNode.RemoveCharNode:       _exec_remove_char(node)
	elif node is DialogNode.ClearNode:            _exec_clear()
	elif node is DialogNode.BranchNode:     await _exec_branch(node)
	elif node is DialogNode.ExitNode:             _exec_exit()

func _exec_say(node: DialogNode.SayNode) -> void:
	say_requested.emit(node.who.char_name, tr(node.text))
	_wait_state = WaitState.INPUT
	await input_advanced
	_wait_state = WaitState.NONE

func _exec_move(node: DialogNode.MoveNode) -> void:
	var n := node.who.char_name
	node.who.position = node.pos
	if _scene_state.characters.has(n):
		_scene_state.characters[n]["position"] = int(node.pos)
	move_requested.emit(n, int(node.pos))

func _exec_distance(node: DialogNode.DistanceNode) -> void:
	var n := node.who.char_name
	node.who.distance = node.dist
	if _scene_state.characters.has(n):
		_scene_state.characters[n]["distance"] = int(node.dist)
	distance_requested.emit(n, int(node.dist))

func _exec_back(node: DialogNode.BackNode) -> void:
	_scene_state["background"] = node.back.resource_path
	background_changed.emit(node.back.resource_path)

func _exec_add_char(node: DialogNode.AddCharNode) -> void:
	var c := node.character
	c.visible = true
	_scene_state.characters[c.char_name] = c.snapshot()
	char_added.emit(c.char_name, c.texture_path)
	move_requested.emit(c.char_name, int(c.position))
	distance_requested.emit(c.char_name, int(c.distance))

func _exec_remove_char(node: DialogNode.RemoveCharNode) -> void:
	var n := node.character.char_name
	node.character.visible = false
	_scene_state.characters.erase(n)
	char_removed.emit(n)

func _exec_clear() -> void:
	_scene_state["background"] = ""
	_scene_state["characters"].clear()
	scene_cleared.emit()

func _exec_branch(node: DialogNode.BranchNode) -> void:
	branch_requested.emit(node.choices)
	_wait_state = WaitState.BRANCH
	var idx: int = await branch_selected
	_wait_state = WaitState.NONE
	
	if _pending_rewind_index != -1:
		return
		
	_branch_history.append(idx)

	var choice: IfEX = node.choices[idx]
	if choice.callback.is_valid():
		choice.callback.call()
	if choice.jump_tag != "":
		if _tag_table.has(choice.jump_tag):
			_current_index = _tag_table[choice.jump_tag] - 1  ## loop 末尾 +1 補回
		else:
			push_warning("DialogManager: tag '%s' 不存在" % choice.jump_tag)

func _exec_exit() -> void:
	_current_index = _nodes.size()  ## 將指針推至末尾，讓迴圈結束

# ── Snapshot ─────────────────────────────────────────────────

func _push_snapshot() -> void:
	var snap            := SceneSnapshot.new()
	snap.node_index      = _current_index
	snap.scene_state     = _scene_state.duplicate(true)
	snap.branch_history  = _branch_history.duplicate()
	_history.append(snap)

func _restore_scene() -> void:
	scene_cleared.emit()
	var bg: String = _scene_state.get("background", "")
	if bg != "":
		background_changed.emit(bg)
	for char_name: String in _scene_state.get("characters", {}):
		var c: Dictionary = _scene_state.characters[char_name]
		char_added.emit(char_name,   c.get("texture_path", ""))
		move_requested.emit(char_name, c.get("position", 0))
		distance_requested.emit(char_name, c.get("distance", CharEX.DISTANCE.MIDGROUND))
