extends Node2D

const BULLET = preload("res://scenes/bullet.tscn")

const SFX_CONTROLLER = preload("res://scenes/sfx_controller.tscn")
var firerate = 1
var cooldown_timer = 0
var bullet_direction = Vector2(1,0)

func _process(delta):
	cooldown_timer += delta
	if cooldown_timer >= firerate:
		cooldown_timer -= firerate
		shoot()
		
func shoot():
	print("BOOM!")
	var bullet = BULLET.instantiate()
	GlobalData.game.add_child(bullet) # add the bullet to the game.....
									   # this looks strange but you want the bullet to be
									   # part of the game so it does not belong to the player
									   # because when the player moves the bullets would move
									   # which would be bad! you silly goose, you!!!!!!!!!!
