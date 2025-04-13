extends Node2D

@onready var enemies = get_tree().get_nodes_in_group("Enemy")
@export var speed = 1500


@onready var direction

signal sfx(sfx_name)


func _ready():
	rotation = direction.angle()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body in enemies:
		emit_signal("sfx", "bullethit")
		body.queue_free()
		queue_free()


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_kill_self_timeout() -> void:
	queue_free()
	pass # Replace with function body.
