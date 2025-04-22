extends Node2D
var enemy_spawn_frequency = 0.5 # in seconds
var spawn_timer = 0

var enemy_scenes: Dictionary = {
	
	
#put the preload(scene) first, and then after put the odds at which they spawn
preload("res://scenes/meatball.tscn") : 1,
preload("res://scenes/tomato.tscn") : 1, 
preload("res://scenes/cookie.tscn") : 1,
preload("res://eggplant.tscn") : 0,
preload("res://assets/easteregg/walterwhite.tscn") : 0.01

}

var max_enemies = 500

func _ready():
	GlobalData.game = self

func _process(delta):
	spawn_enemy(delta)

		
func spawn_enemy(delta):
	spawn_timer += delta
	if spawn_timer >= enemy_spawn_frequency and len(get_tree().get_nodes_in_group("enemies")) < max_enemies:
		spawn_timer = 0
		var rand_enemy_array: Array
		var rand_enemy = pick_weighted_enemy()
		var enemy = rand_enemy.instantiate()
		add_child(enemy)
		var camera = GlobalData.player.get_node("Camera2D")
		var screen_size = get_viewport_rect().size
		var camera_pos = camera.global_position
		
		var spawn_margin := 50  # Distance outside the screen to spawn

		var side = randi() % 4
		var spawn_position = Vector2.ZERO

		match side:
			0:  # Top
				spawn_position = Vector2(
					randf_range(camera_pos.x - screen_size.x / 2, camera_pos.x + screen_size.x / 2),
					camera_pos.y - screen_size.y / 2 - spawn_margin
				)
			1:  # Bottom
				spawn_position = Vector2(
					randf_range(camera_pos.x - screen_size.x / 2, camera_pos.x + screen_size.x / 2),
					camera_pos.y + screen_size.y / 2 + spawn_margin
				)
			2:  # Left
				spawn_position = Vector2(
					camera_pos.x - screen_size.x / 2 - spawn_margin,
					randf_range(camera_pos.y - screen_size.y / 2, camera_pos.y + screen_size.y / 2)
				)
			3:  # Rightwww
				spawn_position = Vector2(
					camera_pos.x + screen_size.x / 2 + spawn_margin,
					randf_range(camera_pos.y - screen_size.y / 2, camera_pos.y + screen_size.y / 2)
				)

		enemy.global_position = spawn_position
		

func pick_weighted_enemy():
	var rng = RandomNumberGenerator.new()
	var enemies = enemy_scenes.keys() as Array
	var weights = enemy_scenes.values() as Array
	var enemy_weights = PackedFloat32Array(weights)
	return enemies[rng.rand_weighted(enemy_weights)]
