extends CharacterBody2D

@export var speed = 200
@onready var camera = $Camera2D  # Assuming the Camera2D node is a child of the player
var previous_global_position = global_position
var mouse_position
var direction = Vector2.ZERO
@onready var ani_player = %AnimationPlayer
@onready var sprite = %Sprite2D
var xp = 0

func _ready():
	GlobalData.player = self

func _physics_process(_delta):
	var input_dir = Input.get_vector("a", "d", "w", "s")
	velocity = input_dir * speed
	move_and_slide()
	mouse_position = get_global_mouse_position()
	
	var presses = 0
	#this animation controller is shit and needs to be changed at some point lol
	
	if Input.is_action_pressed("a") and presses < 1:
		ani_player.play("walk_left")
		presses += 1
	if Input.is_action_pressed("d") and presses < 1:
		ani_player.play("walk_right")
		presses += 1
	if Input.is_action_pressed("s") and presses < 1:
		ani_player.play("walk_down")
		presses += 1
	if Input.is_action_pressed("w") and presses < 1:
		ani_player.play("walk_up")
		presses += 1
	
		
	
		

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
		
