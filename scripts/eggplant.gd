extends Enemy

func _ready():
	%walk.play()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		%Sprite2D.frame = 2
		$Charge.start()
	pass # Replace with function body.

func _on_charge_timeout() -> void:
	%Sprite2D.frame = 3
	%FallHitbox.disabled = false
	$boom.restart()
	%Cooldown.start()
	pass # Replace with function body.

func _on_cooldown_timeout() -> void:
	%FallHitbox.disabled = true
	%Sprite2D.frame = 1
	pass # Replace with function body.


#func _on_area_2d_2_body_entered(body: Node2D) -> void:
	#if body.is_in_group("player"):
		#body.lose_hp(7)
	#pass # Replace with function body.
	#
#func _physics_process(_delta):
	#if GlobalData.player and use_default_movement:
		#var direction = (GlobalData.player.global_position - global_position).normalized()
		#velocity = direction * SPEED
		#move_and_slide()
#
#
		## Flip sprite based on movement direction relative to player
		#if direction.x < 0:
			#scale.x = -0.17
		#elif direction.x > 0:
			#scale.x = 0.17
			#
	#else:
		#velocity = Vector2.ZERO
		#move_and_slide()
