extends Node2D
var enemy_spawn_frequency = 1 # in seconds
var spawn_timer = 0
var difficulty_timer = 0



var enemy_scenes: Dictionary = {
	
	
#put the preload(scene) first, and then after put the odds at which they spawn
preload("res://scenes/meatball.tscn") : 1,
preload("res://scenes/tomato.tscn") : 0, 
preload("res://scenes/cookie.tscn") : 0,
preload("res://scenes/chili.tscn") : 0,
preload("res://scenes/greenchili.tscn") : 0,

#walter white is an easter egg with a stupidly low chance to spawn
preload("res://assets/easteregg/walterwhite.tscn") : 0.00000000001,
}

var max_enemies = 100

func _ready():
	GlobalData.game = self

func _process(delta):
	spawn_enemy(delta)

		
func spawn_enemy(delta):
	spawn_timer += delta
	difficulty_timer += delta
	%timer.text = "TIMER: " + str(int(difficulty_timer))
	
	############################################    ENEMY SPAWNER    ###############################################
	if spawn_timer >= enemy_spawn_frequency and get_tree().get_nodes_in_group("enemies").size() < max_enemies:
		spawn_timer = 0
		
		# Set a random position along the path
		%Player.spawnerpicker.progress_ratio = randf()
		
		# Get the GLOBAL position of the PathFollow2D after it's positioned on the path
		var spawn_position = %Player.spawnerpicker.global_position
		print("Spawning enemy at: ", spawn_position)
		
		var rand_enemy = pick_weighted_enemy()
		var enemy = rand_enemy.instantiate()
		add_child(enemy)
		
		# Use the global position from the path
		enemy.global_position = spawn_position
	################################################################################################################
	############################################ Adjust enemy spawnrates w/ timer here ############################################
	
	if difficulty_timer > 60:
		enemy_spawn_frequency = 0.7
		adjust_spawn_rate(preload("res://scenes/tomato.tscn"), 0.3)
		
	if difficulty_timer > 90:
		enemy_spawn_frequency = 0.6
		adjust_spawn_rate(preload("res://scenes/cookie.tscn"), 0.3)
		adjust_spawn_rate(preload("res://scenes/tomato.tscn"), 0.3)
		adjust_spawn_rate(preload("res://scenes/meatball.tscn"), 0.1)
		
	if difficulty_timer > 120: 
		enemy_spawn_frequency = 0.3
		adjust_spawn_rate(preload("res://scenes/chili.tscn"), 1)
		adjust_spawn_rate(preload("res://scenes/greenchili.tscn"), 0.5)
		adjust_spawn_rate(preload("res://scenes/cookie.tscn"), 0.2)
		adjust_spawn_rate(preload("res://scenes/tomato.tscn"), 0.2)
		adjust_spawn_rate(preload("res://scenes/meatball.tscn"), 0)
		
	###############################################################################################################################

func adjust_spawn_rate(enemy, odds):
	for fella in enemy_scenes:
		if enemy == fella:
			enemy_scenes[fella] = odds


func pick_weighted_enemy():
	var rng = RandomNumberGenerator.new()
	var enemies = enemy_scenes.keys() as Array
	var weights = enemy_scenes.values() as Array
	var enemy_weights = PackedFloat32Array(weights)
	return enemies[rng.rand_weighted(enemy_weights)]
