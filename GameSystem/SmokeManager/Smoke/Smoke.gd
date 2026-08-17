class_name Smoke
extends GPUParticles2D


func _ready() -> void:
	emitting = true
	one_shot = true
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
