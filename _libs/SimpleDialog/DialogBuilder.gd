# res://dialog_system/dialog_builder.gd
class_name DialogBuilder

var _nodes: Array = []       ## Array[DialogNode]
var _pending: DialogNode = null

# ── Internal ──────────────────────────────────────────────────

func _flush() -> void:
	if _pending != null:
		_nodes.append(_pending)
		_pending = null

func _set_pending(node: DialogNode) -> DialogBuilder:
	_flush()
	_pending = node
	return self

## 由 DialogManager.play() 在執行前調用
func build() -> DialogBuilder:
	_flush()
	return self

# ── 通用鏈式操作 ──────────────────────────────────────────────

## 為最後一個節點（待定或已提交）設定 tag
func tag(t: String) -> DialogBuilder:
	if _pending != null:
		_pending.tag = t
	elif not _nodes.is_empty():
		_nodes.back().tag = t
	return self

## 提交待定節點，回傳 self 繼續鏈式
func end() -> DialogBuilder:
	return build()

# ── 場景操作 ──────────────────────────────────────────────────

func set_back(back: BackEX) -> DialogBuilder:
	return _set_pending(DialogNode.BackNode.new(back))

func add_char(character: CharEX) -> DialogBuilder:
	return _set_pending(DialogNode.AddCharNode.new(character))

func remove_char(character: CharEX) -> DialogBuilder:
	return _set_pending(DialogNode.RemoveCharNode.new(character))

func clear_all() -> DialogBuilder:
	return _set_pending(DialogNode.ClearNode.new())

## 分支（branch 取代 GDScript 保留字 if）
func branch(choices: Array) -> DialogBuilder:
	_flush()
	_nodes.append(DialogNode.BranchNode.new(choices))
	return self

## 強制提前結束對話
func exit() -> DialogBuilder:
	return _set_pending(DialogNode.ExitNode.new())

# ── Who 鏈 ────────────────────────────────────────────────────

func who(character: CharEX) -> WhoChain:
	_flush()
	return WhoChain.new(self, character)

# ── 匯出翻譯 CSV ──────────────────────────────────────────────

## 導出所有文本為 CSV（鍵=原文），供 Godot tr() 翻譯流程使用
func get_all_text_csv() -> String:
	build()
	var lines: PackedStringArray = ["keys,en"]
	for node in _nodes:
		if node is DialogNode.SayNode:
			var t: String = (node as DialogNode.SayNode).text
			lines.append('"%s","%s"' % [t.replace('"', '""'), t.replace('"', '""')])
		elif node is DialogNode.BranchNode:
			for choice in (node as DialogNode.BranchNode).choices:
				var t: String = (choice as IfEX).display_text
				lines.append('"%s","%s"' % [t.replace('"', '""'), t.replace('"', '""')])
	return "\n".join(lines)

# ── WhoChain ──────────────────────────────────────────────────

class WhoChain:
	var _builder: DialogBuilder
	var _who: CharEX
	var _node: DialogNode
	var _first_node: DialogNode = null
	var _stored_tag: String = ""

	func _init(builder: DialogBuilder, who: CharEX) -> void:
		_builder = builder
		_who    = who
		_node   = null

	func _flush_chain() -> void:
		if _node != null:
			if _first_node == null:
				_first_node = _node
				if _stored_tag != "":
					_first_node.tag = _stored_tag
			_builder._nodes.append(_node)
			_node = null

	func say(text: String) -> WhoChain:
		_flush_chain()
		_node = DialogNode.SayNode.new(_who, text)
		return self

	func move(pos: CharEX.POS) -> WhoChain:
		_flush_chain()
		_node = DialogNode.MoveNode.new(_who, pos)
		return self

	func distance(dist: CharEX.DISTANCE) -> WhoChain:
		_flush_chain()
		_node = DialogNode.DistanceNode.new(_who, dist)
		return self

	func tag(t: String) -> WhoChain:
		if _first_node != null:
			_first_node.tag = t
		elif _node != null:
			_node.tag = t
			if _first_node == null:
				_first_node = _node
		else:
			_stored_tag = t
		return self

	func end() -> DialogBuilder:
		_flush_chain()
		return _builder
