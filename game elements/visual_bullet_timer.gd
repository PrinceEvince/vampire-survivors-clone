extends TextureProgressBar

func _process(delta: float) -> void:
	if value <= 0:
		pass
	elif value > 0:
		value -= 1
