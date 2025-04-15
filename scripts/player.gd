extends CharacterBody2D

@export var speed = 400
@onready var parent = get_parent()
@onready var camera = $Camera2D  # Assuming the Camera2D node is a child of the player
var mouse_position
var direction

#func _ready():
	## Set the camera to follow the player (this can also be set in the editor)
	#camera.current = true

func get_input():
	var input_direction = Input.get_vector("a", "d", "w", "s")
	velocity = input_direction * speed

func _physics_process(_delta):
	get_input()
	move_and_slide()
	mouse_position = get_global_mouse_position()
	direction = (mouse_position - global_position).normalized()
	$Sprite2D.rotation = direction.angle()
	
