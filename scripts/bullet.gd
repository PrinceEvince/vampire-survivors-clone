extends Node2D

var speed = 900
var lifespan = 3
var direction = Vector2.ZERO # gun node will overwrite this after the instantiation line
var lifespan_timer = 0.0
var bruh = 0

func _ready():
	global_position = GlobalData.player.global_position
	
	

func _physics_process(delta):
	look_at(global_position + direction)
	lifespan_timer += delta
	if lifespan_timer >= lifespan:
		queue_free()
	else:
		global_position += (direction * speed) * delta
