extends CharacterBody2D

var SPEED = 20
var HEALTH = 40

func _ready():
	%AnimationPlayer.play("nom")
	add_to_group("enemies")
	global_position = Vector2( # randomize where the enemy spawns
		randf_range(0, 1200),  # change later to only spawn offscreen
		randf_range(0, 700)
	)
#	%Sprite2D.frame = randi_range(1,4)

func _physics_process(delta: float) -> void:
	var direction = (GlobalData.player.global_position - global_position).normalized() # normalized() removes the distance part and just turns it into directions
	velocity = direction * SPEED
	move_and_slide()
	
	if direction.x < 0:
		$Sprite2D.flip_h = true
	elif direction.x > 0:
		$Sprite2D.flip_h = false

func take_damage(amt):
	HEALTH -= amt
	if HEALTH <= 0:
		die()
		
func die():
	queue_free()
