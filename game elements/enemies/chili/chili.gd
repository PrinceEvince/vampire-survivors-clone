extends Enemy

var BULLET = preload("res://game elements/enemies/chili/bullet.tscn")
var is_in_range = false

func _on_cooldown_timeout() -> void:
	if is_in_range == true:
		$AnimationPlayer.play("shoot")
		var bullet = BULLET.instantiate()
		bullet.global_position = self.global_position
		GlobalData.game.add_child(bullet)
	else:
		$AnimationPlayer.play("idle")

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body == GlobalData.player:
		$Cooldown.start()
		is_in_range = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == GlobalData.player:
		is_in_range = false
