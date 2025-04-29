extends Area2D

var direction = Vector2.ZERO
var speed = 200

func _ready() -> void:
	direction = (GlobalData.player.global_position - global_position).normalized()

func _on_body_entered(body: Node2D) -> void:
	if body == GlobalData.player:
		body.lose_hp(1)
	if body.is_in_group("weapon"):
		queue_free()

func _physics_process(delta):
	look_at(GlobalData.player.global_position + direction)
	global_position += (direction * speed) * delta

func _on_timer_timeout() -> void:
	queue_free()
