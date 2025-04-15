extends Node2D

@onready var enemies = get_tree().get_nodes_in_group("Enemy")

var speed = 900
var lifespan = 3
var direction = Vector2(1,0)
var lifespan_timer = 0.0
var bruh = 0

func _ready():
	global_position = GlobalData.player.global_position

func _physics_process(delta):
	lifespan_timer += delta
	if lifespan_timer >= lifespan:
		queue_free()
	else:
		global_position += (direction * speed) * delta
