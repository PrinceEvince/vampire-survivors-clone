extends Node2D

const KNIFE = preload("res://game elements/weapons/knife/Knife.tscn")
const SFX_CONTROLLER = preload("uid://citd7jx32xp3d")

@export var speed = 800 # the speed at which knives travel
@export var lifespan = 1 # how many seconds the knives last before despawning
@export var direction = Vector2.ZERO # gun node will overwrite this after the instantiation line
@export var lifespan_timer = 0.0 # this should always be zero
@export var firerate = 1.5 # how many knives to throw per second
@export var pierce = 3 # how many enemies the knives pierce
@export var damage = 10 # how much damage the knives do
@export var cooldown_timer = 0 # this should always be zero
@export var knife_direction = Vector2.ZERO # just to initialize the direction to something
@export var level = 1

func _ready():
	for _i in range(1,level):
		level_up()


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
		knife_direction = (closest_enemy.global_position - global_position).normalized()
		var knife = KNIFE.instantiate()
		knife.damage = damage
		knife.pierce = pierce
		knife.speed = speed
		knife.lifespan = lifespan
		knife.direction = knife_direction
		GlobalData.game.add_child(knife) # add the knife to the game.....
										   # this looks strange but you want the knife to be
										   # part of the game so it does not belong to the player
										   # because when the player moves the bullets would move
										   # which would be bad! you silly goose, you!!!!!!!!!!
func level_up():								
	level += 1
	if level == 2:
		damage += 3
	elif level == 3:
		pierce += 2
	elif level == 4:
		firerate += 0.5
	elif level == 5:
		speed += 200
		lifespan += 1
		damage += 3
	elif level == 6:
		firerate += 0.5
		pierce += 2
	else:
		pass
