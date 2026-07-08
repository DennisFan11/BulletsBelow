# res://dialog_system/dialog_node.gd
class_name DialogNode

## 所有節點的基底類別
var tag: String = ""

# ── 子節點型別 ────────────────────────────────────────────────

class SayNode extends DialogNode:
	var who: CharEX
	var text: String
	func _init(w: CharEX, t: String) -> void:
		who = w; text = t

class MoveNode extends DialogNode:
	var who: CharEX
	var pos: CharEX.POS
	func _init(w: CharEX, p: CharEX.POS) -> void:
		who = w; pos = p

class DistanceNode extends DialogNode:
	var who: CharEX
	var dist: CharEX.DISTANCE
	func _init(w: CharEX, d: CharEX.DISTANCE) -> void:
		who = w; dist = d

class BackNode extends DialogNode:
	var back: BackEX
	func _init(b: BackEX) -> void:
		back = b

class AddCharNode extends DialogNode:
	var character: CharEX
	func _init(c: CharEX) -> void:
		character = c

class RemoveCharNode extends DialogNode:
	var character: CharEX
	func _init(c: CharEX) -> void:
		character = c

class ClearNode extends DialogNode:
	pass

class BranchNode extends DialogNode:
	var choices: Array  ## Array[IfEX]
	func _init(c: Array) -> void:
		choices = c

class ExitNode extends DialogNode:
	pass
