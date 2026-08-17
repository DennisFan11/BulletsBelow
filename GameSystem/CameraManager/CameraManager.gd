extends Camera2D


func _ready() -> void:
	DI.register("_camera_manager", self)



var _player: Player

const LERP_SPEED = 10.0
func _process(delta: float) -> void:
	offset = offset.lerp(_player.get_player_global_pos(), LERP_SPEED * delta)
