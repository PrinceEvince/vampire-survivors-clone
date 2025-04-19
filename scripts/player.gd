extends CharacterBody2D

@export var speed = 200
@onready var camera = $Camera2D  # Assuming the Camera2D node is a child of the player
var previous_global_position = global_position
var mouse_position
var direction
@onready var ani_player = %AnimationPlayer
@onready var sprite = %Sprite2D

func _ready():
	GlobalData.player = self

func get_input():
	var input_direction = Input.get_vector("a", "d", "w", "s")
	velocity = input_direction * speed

func _physics_process(_delta):
	get_input()
	move_and_slide()
	mouse_position = get_global_mouse_position()
	#direction = (mouse_position - global_position).normalized()
	#$Sprite2D.rotation = direction.angle()
	
	if Input.is_action_pressed("w"):
		ani_player.play("walk_up")
		
	if Input.is_action_pressed("d"):
		ani_player.play("walk_right")
		
	if Input.is_action_pressed("s"):
		ani_player.play("walk_down")
		
	if Input.is_action_pressed("a"):
		ani_player.play("walk_left")
	
		

func get_closest_enemy():
	if len(get_tree().get_nodes_in_group("enemies")) == 0:
		return null
	else:
		var closest_enemy_distance = INF
		var closest_enemy_reference = Node2D
		for enemy in get_tree().get_nodes_in_group("enemies"):
			var distance = global_position.distance_to(enemy.global_position)
			if distance < closest_enemy_distance:
				closest_enemy_distance = distance
				closest_enemy_reference = enemy
		return closest_enemy_reference
