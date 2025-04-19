extends CharacterBody2D  # Or the type of node you're working with

var SPEED = 50
var HEALTH = 15

func _ready():
	add_to_group("enemies")
	global_position = Vector2( # randomize where the enemy spawns
		randf_range(0, 1200),  # change later to only spawn offscreen
		randf_range(0, 700)
	)

func _physics_process(delta):
	var direction = (GlobalData.player.global_position - global_position).normalized() # normalized() removes the distance part and just turns it into directions
	velocity = direction * SPEED
	move_and_slide()
	
	if direction.x > 0:
		$Sprite2D.flip_h = true
	elif direction.x < 0:
		$Sprite2D.flip_h = false
	

func take_damage(amt):
	HEALTH -= amt
	if HEALTH <= 0:
		die()
		
func die():
	queue_free()
