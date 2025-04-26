extends Area2D

@export var firerate = 0.2 # how fast the laser does dmg in seconds
@export var initial_damage = 1 # Store the base damage
@export var range: float # range of the laser
@export var cooldown_between_targets = 1.0
var LASER: PackedScene = preload("res://scenes/Laser.tscn")
var direction = Vector2.ZERO
var cooldown_between_targets_timer = 0
var current_damage = 1 # Damage used in calculations, starts at initial
var firerate_timer = 0.0
var targetted_enemy = null
var added = false
var laser


func _ready():
	laser = LASER.instantiate()

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
	current_damage = current_damage + 0.25
	print("Damage ramped up to: ", current_damage)
