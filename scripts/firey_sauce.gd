extends Area2D

@export var firerate = 0.2 # how fast the laser does dmg in seconds
@export var initial_damage = 1 # Store the base damage
@export var range: float = 400# range of the laser
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
@export var ricochet = true
@export var ricochet_amt = 0
@export var targetted_enemies_ricochet = []
@export var ricochet_distance = 100
var lasers = []

func _ready():
	laser = LASER.instantiate()
	lasers.append(laser)
	GlobalData.game.add_child(laser)
	for _i in range(ricochet_amt):
		var laser = LASER.instantiate()
		lasers.append(laser)
		GlobalData.game.add_child(laser)
	for _i in range(1,level):
		level_up()

func _process(delta):
	if targetted_enemy:
		if laser.visible == false:
			laser.visible = true
		direction = (global_position - targetted_enemy.global_position).normalized()
		look_at(global_position + direction)
		laser.points = [$"Tip of Bottle".global_position, targetted_enemy.global_position]
		shoot(delta)
	else:
		reset()
		if cooldown_between_targets_timer >= cooldown_between_targets:
			cooldown_between_targets_timer = 0
			targetted_enemy = GlobalData.player.get_highest_hp_enemy_nearby(range)
			if targetted_enemy:
				laser.points = [$"Tip of Bottle".global_position, targetted_enemy.global_position]
		else:
			cooldown_between_targets_timer += delta
			
	if ricochet_amt > 0 and targetted_enemy != null:
		get_ricochet_targets()
		
	print(targetted_enemies_ricochet)

func get_ricochet_targets():
	var counter = 0
	var target
	var enemy_closest_to_target
	for _i in range(ricochet_amt):
		if len(targetted_enemies_ricochet) == 0:
			target = targetted_enemy
			enemy_closest_to_target = target.get_closest_enemy(targetted_enemies_ricochet)
		else:
			target = targetted_enemies_ricochet[len(targetted_enemies_ricochet)-1]
			enemy_closest_to_target = target.get_closest_enemy(targetted_enemies_ricochet)
		if enemy_closest_to_target == null:
			break
		else:
			if target.global_position.distance_to(enemy_closest_to_target.global_position) <= ricochet_distance:
				targetted_enemies_ricochet.append(enemy_closest_to_target)
				counter += 1
			else:
				break
			
			
				
				
# called to check if current targets are out of reach
# if main target is out of reach then shut down laser
# and initiate cooldown
# if ricochet targets are out of reach then just stop
# shooting them lol
func prune_out_of_reach_targets():
	# Check distance from player to the main target
	if GlobalData.player.global_position.distance_to(targetted_enemy.global_position) > range:
		reset()
		return

	if len(targetted_enemies_ricochet) > 1:
		var last_valid_index = 0
		for i in range(len(targetted_enemies_ricochet) - 1):
			var current_target = targetted_enemies_ricochet[i]
			var next_target = targetted_enemies_ricochet[i+1]
			if not is_instance_valid(current_target) or not is_instance_valid(next_target):
				break
			if current_target.global_position.distance_to(next_target.global_position) > ricochet_distance:
				break
			last_valid_index = i + 1
		var valid_chain_size = last_valid_index + 1
		if valid_chain_size < len(targetted_enemies_ricochet):
			targetted_enemies_ricochet.resize(valid_chain_size)
					
					
func reset():
	if laser.visible:
		laser.visible = false
		targetted_enemies_ricochet.clear()
		current_damage = initial_damage
		
		
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
		
