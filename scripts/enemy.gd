extends Node2D  # Or the type of node you're working with

var SPEED = 50

func _ready():
	GlobalData.enemies.append(self)
	global_position = Vector2( # randomize where the enemy spawns
		randf_range(0, 1200),  # change later to only spawn offscreen
		randf_range(0, 700)
	)

	%Sprite2D.frame = randi_range(1,4)

func _process(delta):
	var direction = (GlobalData.player.global_position - global_position).normalized() # normalized() removes the distance part and just turns it into directions
	global_position += direction * SPEED * delta
	rotation = direction.angle()
