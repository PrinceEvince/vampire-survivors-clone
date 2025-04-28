extends Area2D

@export var firerate = 0.2 # how fast the laser does dmg in seconds
@export var initial_damage = 1 # Store the base damage
@export var range: float # range of the laser
@export var cooldown_between_targets = 1.0
@export var ramp_damage = 0.25
var LASER: PackedScene = preload("res://scenes/Laser.tscn")
var direction = Vector2.ZERO
var cooldown_between_targets_timer = 0
var current_damage = 1 # Damage used in calculations, starts at initial
var firerate_timer = 0.0
var targetted_enemy = null
var added = false
var laser
@export var level = 1

func _ready():
	laser = LASER.instantiate()
	for _i in range(1,level):
		level_up()

func _process(delta):
	# add the laser to the game as soon as the game exists in globaldata
	if not added:
		if GlobalData.game:
			GlobalData.game.add_child(laser)
			added = true
			
	if targetted_enemy:
		if laser.visible == false:
			laser.visible = true
		direction = (global_position - targetted_enemy.global_position).normalized()
		look_at(global_position + direction)
		laser.points = [$"Tip of Bottle".global_position, targetted_enemy.global_position]
		shoot(delta)
	else:
		if laser.visible:
			laser.make_invisible() # need to delete particles so a function was made for this instead of setting visible to false
			laser.visible = false
		current_damage = initial_damage
		if cooldown_between_targets_timer >= cooldown_between_targets:
			cooldown_between_targets_timer = 0
			targetted_enemy = GlobalData.player.get_highest_hp_enemy_nearby(range)
			if targetted_enemy:
				laser.points = [$"Tip of Bottle".global_position, targetted_enemy.global_position]
		else:
			cooldown_between_targets_timer += delta

func shoot(delta):
	firerate_timer += delta
	if firerate_timer >= firerate:
		targetted_enemy.take_damage(current_damage)
		ramp_up()
		firerate_timer = 0


func ramp_up():
	current_damage = current_damage + ramp_damage
	print("Damage ramped up to: ", current_damage)


func level_up():
	level += 1
	if level == 2:
		cooldown_between_targets -= 0.3
	elif level == 3:
		initial_damage += 1
	elif level == 4:
		cooldown_between_targets -= 0.2
		firerate -= 0.1
	elif level == 5:
		ramp_damage += 0.125
	elif level == 6:
		initial_damage += 1
		cooldown_between_targets -= 0.1
		firerate += 0.02
		ramp_damage += 0.05
	else:
		pass
		# idea for future upgrade: laser ricochets to other enemies?
		
