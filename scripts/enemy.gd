extends Node2D  # Or the type of node you're working with

@export var player_path: String = "/root/Game/Player"
@onready var player = get_node(player_path)
var SPEED = 50

func _ready():
	global_position = Vector2( # randomize where the enemy spawns
		randf_range(0, 1200),  # change later to only spawn offscreen
		randf_range(0, 700)
	)
	
func _process(delta):
	var direction = (player.global_position - global_position).normalized() # normalized() removes the distance part and just turns it into directions
	if global_position == player.global_position:
		print("bruh")
	global_position += direction * SPEED * delta
