extends CPUParticles2D
var timer = 0
func _process(delta):
	timer += delta
	if timer >= lifetime:
		queue_free()
