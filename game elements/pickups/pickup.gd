class_name Pickup
extends Area2D


@export var min_speed: float = 0.003        # Speed when player is at the edge of detection_range
@export var max_speed: float = 500.0        # Speed when player is very close
@export var detection_range: float = 140.0  # How far the player needs to be to start attracting XP
@onready var pickup_sfx = $AudioStreamPlayer2D
@export var pitch_scale = true
@export var vacuum = true
@export var timeout_length = 1 # in seconds
var timeout_length_timer = 0
var collected = false

func _ready():
	add_to_group("pickups")


func _on_body_entered(body):
	if body == GlobalData.player:
		pickup()
		
		
func _physics_process(delta: float) -> void:
	if vacuum:
		var player_pos = GlobalData.player.global_position
		var dist = global_position.distance_to(player_pos)
		if dist < detection_range and detection_range > 0:
			var closeness_ratio = 1.0 - clamp(dist / detection_range, 0.0, 1.0)
			var current_speed = lerp(min_speed, max_speed, closeness_ratio)
			var direction = (player_pos - global_position).normalized()
			global_position += direction * current_speed * delta


func _process(delta):
	if collected:
		timeout_length -= delta
		if timeout_length <= 0:
			print("gone") # debug
			queue_free()
		

func pickup():
	shutup()
	collected = true
	if pitch_scale == true:
		pickup_sfx.pitch_scale = randi_range(0.1,4)
	pickup_sfx.play()
	give_player_stuff()
	$Sprite2D.queue_free()
	$CollisionShape2D.queue_free()


func give_player_stuff():
	pass # override this method to give player stuff depending on what type of pickup it is


func shutup():
	# slightly fancy code to only stop sfx of the same type of object that was picked up (thx chatgpt)
	var my_script = self.get_script()
	for node in get_tree().get_nodes_in_group("pickups"):
		if node.get_script() == my_script:
			node.pickup_sfx.stop()
