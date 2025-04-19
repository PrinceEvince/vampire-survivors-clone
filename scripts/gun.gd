extends Node2D

const BULLET = preload("res://scenes/bullet.tscn")

const SFX_CONTROLLER = preload("res://scenes/sfx_controller.tscn")
var firerate = 0.5
var pierce = 7
var damage = 30
var cooldown_timer = 0
var bullet_direction = Vector2.ZERO

func _process(delta):
	cooldown_timer += delta
	if cooldown_timer >= firerate:
		cooldown_timer -= firerate
		shoot()

func shoot():
	print("BOOM!")
	var closest_enemy = GlobalData.player.get_closest_enemy()
	if closest_enemy == null:
		pass
	else:
		bullet_direction = (closest_enemy.global_position - global_position).normalized()
		var bullet = BULLET.instantiate()
		bullet.damage = damage
		bullet.pierce = pierce
		bullet.direction = bullet_direction
		GlobalData.game.add_child(bullet) # add the bullet to the game.....
										   # this looks strange but you want the bullet to be
										   # part of the game so it does not belong to the player
										   # because when the player moves the bullets would move
										   # which would be bad! you silly goose, you!!!!!!!!!!
									
