extends Area2D

var speed = 900
var lifespan = 2
var direction = Vector2.ZERO # gun node will overwrite this after the instantiation line
var lifespan_timer = 0.0
var bruh = 0
var damage
var pierce
var pierce_counter = 0

func _ready():
	global_position = GlobalData.player.global_position
	
func _physics_process(delta):
	look_at(global_position + direction)
	lifespan_timer += delta
	if lifespan_timer >= lifespan:
		die()
		
	else:
		global_position += (direction * speed) * delta
		$BulletSprite.visible = true

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.take_damage(damage)
		pierce_counter += 1
		if pierce_counter == pierce:
			die()

func die():
	queue_free()
