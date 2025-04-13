extends CharacterBody2D

@export var speed = 400
@onready var parent = get_parent()

func _ready():
	print(parent)


func get_input():
	var input_direction = Input.get_vector("a", "d", "w", "s")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	rotation = direction.angle()
	
	
