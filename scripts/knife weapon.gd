extends Node2D

const KNIFE = preload("res://scenes/Knife.tscn")
const SFX_CONTROLLER = preload("res://scenes/sfx_controller.tscn")

@export var speed = 800 # the speed at which knives travel
@export var lifespan = 2 # how many seconds the knives last before despawning
@export var direction = Vector2.ZERO # gun node will overwrite this after the instantiation line
@export var lifespan_timer = 0.0 # this should always be zero
@export var firerate = 1.5 # how many knives to throw per second
@export var pierce = 700 # how many enemies the knives pierce
@export var damage = 10 # how much damage the knives do
@export var cooldown_timer = 0 # this should always be zero
@export var bullet_direction = Vector2.ZERO # just to initialize the direction to something

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
		var knife = KNIFE.instantiate()
		knife.damage = damage
		knife.pierce = pierce
		knife.speed = speed
		knife.lifespan = lifespan
		knife.direction = bullet_direction
		GlobalData.game.add_child(knife) # add the knife to the game.....
										   # this looks strange but you want the knife to be
										   # part of the game so it does not belong to the player
										   # because when the player moves the bullets would move
										   # which would be bad! you silly goose, you!!!!!!!!!!
									
