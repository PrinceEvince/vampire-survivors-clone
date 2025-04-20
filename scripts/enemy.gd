class_name Enemy
extends CharacterBody2D

const XP = preload("res://scenes/xp.tscn")
@export var SPEED = 50
@export var HEALTH = 15
@onready var sprite: Sprite2D = $Sprite2D
# aaaa

# --- Color and Tween Params ---
# Use float values (0.0 to 1.0) for colors
@export var hurt_color = Color(1.0, 0.5, 0.5)  # Reddish tint for hurt effect
# Or use white flash: var hurt_color = Color(1.0, 1.0, 1.0)
@export var normal_color = Color(1.0, 1.0, 1.0) # Default modulate is usually white
@export var hurt_effect_duration = 0.15 # Total time for the flash (flash on + flash off)
# Variable to store the active hurt tween
var active_hurt_tween: Tween

func _ready():
	add_to_group("enemies")
	global_position = Vector2(
		randf_range(0, 1200),
		randf_range(0, 700)
	)
func _physics_process(_delta):
	if GlobalData.player:
		var direction = (GlobalData.player.global_position - global_position).normalized()
		velocity = direction * SPEED
		move_and_slide()

		# Flip sprite based on movement direction relative to player
		if direction.x > 0:
			sprite.flip_h = true
		elif direction.x < 0:
			sprite.flip_h = false
	else:
		velocity = Vector2.ZERO
		move_and_slide()


func take_damage(amt):
	HEALTH -= amt

	# --- Check for Death ---
	if HEALTH <= 0:
		die()

	if active_hurt_tween and active_hurt_tween.is_valid():
		active_hurt_tween.kill()

	if not sprite:
		printerr("Enemy: Sprite2D node not found for tweening!")
		return

	active_hurt_tween = create_tween()
	active_hurt_tween.tween_property(sprite, "modulate", hurt_color, hurt_effect_duration / 2.0)
	active_hurt_tween.tween_property(sprite, "modulate", normal_color, hurt_effect_duration / 2.0)


func die():
	var xp = XP.instantiate()
	xp.global_position = global_position
	GlobalData.game.add_child(xp)
	queue_free() # Remove the enemy node from the scene
