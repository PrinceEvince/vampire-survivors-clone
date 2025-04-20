extends Area2D

var pierce_counter = 0
var lifespan_timer = 0.0

# the following variables are defined in the knife_weapon.gd script
var damage
var pierce
var lifespan
var direction
var speed

func _ready():
	global_position = GlobalData.player.global_position
	
func _physics_process(delta):
	look_at(global_position + direction)
	lifespan_timer += delta
	if lifespan_timer >= lifespan:
		die()
	else:
		global_position += (direction * speed) * delta
		$KnifeSprite.visible = true

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.take_damage(damage)
		pierce_counter += 1
		if pierce_counter == pierce:
			die()

func die():
	queue_free()
