extends Node2D
var enemy_spawn_frequency = 0.5 # in seconds
var spawn_timer = 0
@export var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")
var enemies = []

func _process(delta):
	spawn_timer += delta
	if spawn_timer >= enemy_spawn_frequency:
		spawn_enemy()
		
func spawn_enemy():
	spawn_timer = 0
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemies.append(enemy)
