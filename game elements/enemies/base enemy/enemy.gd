class_name Enemy
extends CharacterBody2D

const EXPLOSION_PARTICLES = preload(("res://game elements/enemies/base enemy/particle_explosion.tscn"))
const XP_PICKUP = preload("res://game elements/pickups/xp/xp_pickup.tscn")
const GEM_PICKUP = preload("res://game elements/pickups/gem/gem_pickup.tscn")
const HEALTH_PICKUP = preload("res://game elements/pickups/health/health_pickup.tscn")
@export var SPEED = 50
@export var HEALTH = 15
@onready var sprite: Sprite2D = $Sprite2D
@export var min_xp_dropped = 0
@export var max_xp_dropped = 0
@export var particle_texture: Texture2D
# --- Color and Tween Params ---
# Use float values (0.0 to 1.0) for colors
@export var hurt_color = Color(1.0, 0.5, 0.5)  # Reddish tint for hurt effect
# Or use white flash: var hurt_color = Color(1.0, 1.0, 1.0)
@export var normal_color = Color(1.0, 1.0, 1.0) # Default modulate is usually white
@export var hurt_effect_duration = 0.15 # Total time for the flash (flash on + flash off)
# Variable to store the active hurt tween
@export var use_default_movement: bool = true
var active_hurt_tween: Tween
var newaudioplayer


func _ready():
	add_to_group("enemies")
	global_position = Vector2(
		randf_range(0, 1200),
		randf_range(0, 700)
	)
	
	newaudioplayer = AudioStreamPlayer2D.new()
	add_child(newaudioplayer)
	
func _physics_process(_delta):
	if GlobalData.player and use_default_movement:
		var direction = (GlobalData.player.global_position - global_position).normalized()
		velocity = direction * SPEED
		move_and_slide()

		# Flip sprite based on movement direction relative to player
		if direction.x > 0:
			sprite.flip_h = false
		elif direction.x < 0:
			sprite.flip_h = true
	else:
		velocity = Vector2.ZERO
		move_and_slide()


func take_damage(amt):
	# --- Check for Death ---
	if HEALTH <= 0:
		die()
	
	HEALTH -= amt
	
	var hurt_sfx: Array[AudioStream] = [
	preload("res://game elements/enemies/base enemy/hit1.ogg"),
	preload("res://game elements/enemies/base enemy/hit2.ogg"),
	preload("res://game elements/enemies/base enemy/hit3.ogg"),
	preload("res://game elements/enemies/base enemy/hit4.ogg")
]
	newaudioplayer.stream = hurt_sfx.pick_random()
	newaudioplayer.play()
	
	# add on-hit particles
	var explosion_particles = EXPLOSION_PARTICLES.instantiate()
	explosion_particles.texture = particle_texture
	explosion_particles.global_position = global_position
	explosion_particles.amount = 6
	explosion_particles.emitting = true
	GlobalData.game.add_child(explosion_particles)

	if active_hurt_tween and active_hurt_tween.is_valid():
		active_hurt_tween.kill()

	if not sprite:
		printerr("Enemy: Sprite2D node not found for tweening!")
		return

	active_hurt_tween = create_tween()
	active_hurt_tween.tween_property(sprite, "modulate", hurt_color, hurt_effect_duration / 2.0)
	active_hurt_tween.tween_property(sprite, "rotation_degrees", randi_range(-60, 60), 0.06)
	active_hurt_tween.tween_property(sprite, "rotation_degrees", 0, 0.06)
	active_hurt_tween.tween_property(sprite, "modulate", normal_color, hurt_effect_duration / 2.0)


func die():
	set_physics_process(false)
	drop_stuff()
	add_death_particles()
	randomize()
	queue_free() # Remove the enemy node from the scene


func get_closest_enemy(excluded_enemies: Array):
	if len(get_tree().get_nodes_in_group("enemies")) == 0:
		return null
	else:
		var closest_enemy_distance = INF
		var closest_enemy_reference = Node2D
		for enemy in get_tree().get_nodes_in_group("enemies"):
			if enemy == self or enemy in excluded_enemies:
				pass
			else:
				var distance = global_position.distance_to(enemy.global_position)
				if distance < closest_enemy_distance:
					closest_enemy_distance = distance
					closest_enemy_reference = enemy
		return closest_enemy_reference


func drop_stuff():
	var amt_xp_dropped = randi_range(min_xp_dropped, max_xp_dropped+1)
	add_pickup_to_world(XP_PICKUP, amt_xp_dropped)

	var gem_chance = randi_range(GlobalData.player.gem_drop_chance_numerator, GlobalData.player.gem_drop_chance_denominator)
	if gem_chance == 1:
		add_pickup_to_world(GEM_PICKUP, 1)

	var health_chance = randi_range(GlobalData.player.health_drop_chance_numerator, GlobalData.player.health_drop_chance_denominator)
	if health_chance == 1:
		add_pickup_to_world(HEALTH_PICKUP, 1)
	
func add_pickup_to_world(pickup_type: PackedScene, amt: int):
	for num in range(0,amt): # yes the zero is intentional do not remove
		var random_offset = Vector2(randf_range(-75, 75), randf_range(-75, 75))
		var pickup = pickup_type.instantiate()
		pickup.global_position = global_position + random_offset
		GlobalData.game.add_child(pickup)

func add_death_particles():
	# add death particles
	var explosion_particles = EXPLOSION_PARTICLES.instantiate()
	if particle_texture:
		explosion_particles.texture = particle_texture
	explosion_particles.global_position = global_position
	explosion_particles.amount = 30
	explosion_particles.emitting = true
	GlobalData.game.add_child(explosion_particles)


func _on_timer_timeout() -> void:
	if global_position.distance_to(GlobalData.player.global_position) > 500:
		print("despawning")
		queue_free()
