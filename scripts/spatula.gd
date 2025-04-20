extends Node2D

@export var swing_time = 0.3
var damage = 5

func _ready(): # this runs when the scene is instantiated
	swing()

func swing():
	var rotate_tween = create_tween().set_loops()
	rotate_tween.tween_property(self, "rotation", deg_to_rad(360), swing_time).from(0.0)

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.take_damage(damage)
