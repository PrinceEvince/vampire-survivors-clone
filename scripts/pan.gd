extends Area2D

@export var speed = 0.23
@export var rotation_amt = 160
@export var damage = 1

var rotating_tween: Tween
var direction := 1  # 1 = right, -1 = left

func _ready():
	start_rotation_tween(direction)

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.take_damage(damage)

func _process(delta):
	if Input.is_action_just_pressed("d") and direction != 1:
		direction = 1
		flip_weapon(direction)
	elif Input.is_action_just_pressed("a") and direction != -1:
		direction = -1
		flip_weapon(direction)

func flip_weapon(dir: int):
	# Flip visuals
	scale.x = dir
	
	# Restart rotation tween with new direction
	start_rotation_tween(dir)

func start_rotation_tween(dir: int):
	if rotating_tween and rotating_tween.is_running():
		rotating_tween.kill()  # Kill old tween before starting new one

	rotating_tween = create_tween().set_loops(0)

	# Swing from -rotation_amt/2 to +rotation_amt/2 (or reversed if flipped)
	var from_angle = -rotation_amt / 2 * dir
	var to_angle = rotation_amt / 2 * dir

	rotating_tween.tween_property(self, "rotation_degrees", to_angle, speed / 2).from(from_angle)
	rotating_tween.tween_property(self, "rotation_degrees", from_angle, 0).set_delay(speed / 2)
