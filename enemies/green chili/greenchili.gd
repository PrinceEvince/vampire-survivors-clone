extends Enemy

var BULLET = preload("res://scenes/greenbullet.tscn")
var is_in_range = false
var bullets_fired: int = 0
var can_fire: bool = true

func _on_cooldown_timeout() -> void:
	if is_in_range and can_fire:
		if bullets_fired < 6:
			$AnimationPlayer.play("shoot")
			var bullet = BULLET.instantiate()
			bullet.global_position = self.global_position
			GlobalData.game.add_child(bullet)
			bullets_fired += 1
			$Cooldown.start()  # restart cooldown for next bullet
		else:
			can_fire = false
			$AnimationPlayer.play("idle")
			$Cooldown2.start()  # start burst cooldown

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body == GlobalData.player:
		$Cooldown.start()
		is_in_range = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == GlobalData.player:
		is_in_range = false

func _on_cooldown_2_timeout() -> void:
	bullets_fired = 0
	can_fire = true
	if is_in_range:
		$Cooldown.start()  # start firing again if player still in range
