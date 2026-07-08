# res://dialog_system/scene_snapshot.gd
class_name SceneSnapshot

var node_index: int = 0
## { "background": String, "characters": { char_name: Dictionary } }
var scene_state: Dictionary = {}
## 記錄分支選擇歷史，回朔時重建路徑用
var branch_history: Array = []  ## Array[int]
