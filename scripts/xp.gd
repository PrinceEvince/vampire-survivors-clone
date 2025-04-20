extends Area2D



func _on_body_entered(body):
	if body == GlobalData.player:
		die()
	
func die():
	queue_free()
	
func _on_timer_timeout() -> void:
	die()
