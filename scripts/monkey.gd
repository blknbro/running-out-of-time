extends AnimatedSprite2D


func _process(delta: float) -> void:
	if get_parent().game_running:
		self.play("run")
