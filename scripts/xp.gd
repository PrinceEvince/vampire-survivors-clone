extends Area2D


@export var min_speed: float = 0.003        # Speed when player is at the edge of detection_range
@export var max_speed: float = 500.0        # Speed when player is very close
@export var detection_range: float = 140.0  # How far the player needs to be to start attracting XP
@export var xp = 0
@onready var xp_pickup_sfx = $AudioStreamPlayer2D

func _ready():
	add_to_group("xp")


func _on_body_entered(body):
	if body == GlobalData.player:
		body.gain_xp(1)
		pickup()
		

func _physics_process(delta: float) -> void:
	var player_pos = GlobalData.player.global_position
	var dist = global_position.distance_to(player_pos)
	if dist < detection_range and detection_range > 0:
		var closeness_ratio = 1.0 - clamp(dist / detection_range, 0.0, 1.0)
		var current_speed = lerp(min_speed, max_speed, closeness_ratio)
		var direction = (player_pos - global_position).normalized()
		global_position += direction * current_speed * delta

func pickup():
	shutup()
	GlobalData.player.xp += 1
	xp_pickup_sfx.pitch_scale = randi_range(0.1,4)
	xp_pickup_sfx.play()
	$Sprite2D.hide()
	$Timer.start()
	
func _on_timer_timeout() -> void:
	queue_free()

func shutup():
	for node in get_tree().get_nodes_in_group("xp"):
		node.xp_pickup_sfx.stop()
