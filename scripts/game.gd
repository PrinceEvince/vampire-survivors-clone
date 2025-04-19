extends Node2D
var enemy_spawn_frequency = 0.01 # in seconds
var spawn_timer = 0
var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")
var max_enemies = 1200

func _ready():
	GlobalData.game = self

func _process(delta):
	spawn_enemy(delta)

		
func spawn_enemy(delta):
	spawn_timer += delta
	if spawn_timer >= enemy_spawn_frequency and len(get_tree().get_nodes_in_group("enemies")) < max_enemies:
		spawn_timer = 0
		var enemy = enemy_scene.instantiate()
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
			3:  # Right
				spawn_position = Vector2(
					camera_pos.x + screen_size.x / 2 + spawn_margin,
					randf_range(camera_pos.y - screen_size.y / 2, camera_pos.y + screen_size.y / 2)
				)

		enemy.global_position = spawn_position
