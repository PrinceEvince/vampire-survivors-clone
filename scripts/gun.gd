extends Node2D

const BULLET = preload("res://scenes/bullet.tscn")

const SFX_CONTROLLER = preload("res://scenes/sfx_controller.tscn")
var firerate = 0.3
var pierce = 1
var damage = 5
var cooldown_timer = 0
var bullet_direction = Vector2(1,0)

func _process(delta):
	cooldown_timer += delta
	if cooldown_timer >= firerate:
		cooldown_timer -= firerate
		shoot()

func shoot():
	print("BOOM!")
	var closest_enemy = get_closest_enemy()
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
									
func get_closest_enemy():
	if len(get_tree().get_nodes_in_group("enemies")) == 0:
		return null
	else:
		var closest_enemy_distance = INF
		var closest_enemy_reference = Node2D
		for enemy in get_tree().get_nodes_in_group("enemies"):
			var distance = global_position.distance_to(enemy.global_position)
			if distance < closest_enemy_distance:
				closest_enemy_distance = distance
				closest_enemy_reference = enemy
		return closest_enemy_reference
