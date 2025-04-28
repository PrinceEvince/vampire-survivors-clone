extends Node2D

@export var swing_time = 0.3
@export var level = 1
@export var damage = 5


func _ready(): # this runs when the scene is instantiated
	swing()
	for _i in range(1,level):
		level_up()

func swing():
	var rotate_tween = create_tween().set_loops()
	rotate_tween.tween_property(self, "rotation", deg_to_rad(360), swing_time).from(0.0)

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.take_damage(damage)


func level_up():
	level += 1
	if level == 2:
		damage += 2
	elif level == 3:
		swing_time -= 0.75
	elif level == 4:
		swing_time -= 0.25
		damage += 1
	elif level == 5:
		swing_time -= 0.25
		damage += 1
	else:
		pass
