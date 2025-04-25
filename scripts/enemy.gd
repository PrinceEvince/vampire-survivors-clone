class_name Enemy
extends CharacterBody2D

const EXPLOSION_PARTICLES = preload(("res://scenes/particle_explosion.tscn"))
const XP_PICKUP = preload("res://scenes/xp_pickup.tscn")
const GEM_PICKUP = preload("res://scenes/gem_pickup.tscn")
const HEALTH_PICKUP = preload("res://scenes/health_pickup.tscn")
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
	preload("res://assets/audio/hit1.ogg"),
	preload("res://assets/audio/hit2.ogg"),
	preload("res://assets/audio/hit3.ogg"),
	preload("res://assets/audio/hit4.ogg")
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
	active_hurt_tween.tween_property(sprite, "rotation_degrees", 50, 0.06)
	active_hurt_tween.tween_property(sprite, "rotation_degrees", 0, 0.06)
	active_hurt_tween.tween_property(sprite, "modulate", normal_color, hurt_effect_duration / 2.0)



func die():
	set_physics_process(false)
	randomize()
	for num in randf_range(min_xp_dropped, ((randi() % (max_xp_dropped+1))+min_xp_dropped)):
		var xp = XP_PICKUP.instantiate()
		var random_offset = Vector2(randf_range(-75, 75), randf_range(-75, 75))
		xp.global_position = global_position + random_offset
		GlobalData.game.add_child(xp)
	
	var gem_chance = randi_range(1,2)
	# print("number generated: ", gem_chance) # debug
	if gem_chance == 1:
		var gem = GEM_PICKUP.instantiate()
		gem.global_position = self.position
		var random_offset = Vector2(randf_range(-75, 75), randf_range(-75, 75))
		gem.global_position = global_position + random_offset
		GlobalData.game.add_child(gem)
		
	var health_chance = randi_range(1,1)
	# print("number generated: ", gem_chance) # debug
	if health_chance == 1:
		var health = HEALTH_PICKUP.instantiate()
		health.global_position = self.position
		var random_offset = Vector2(randf_range(-75, 75), randf_range(-75, 75))
		health.global_position = global_position + random_offset
		GlobalData.game.add_child(health)
	
	
	# add death particles
	var explosion_particles = EXPLOSION_PARTICLES.instantiate()
	if particle_texture:
		explosion_particles.texture = particle_texture
	explosion_particles.global_position = global_position
	explosion_particles.amount = 30
	explosion_particles.emitting = true
	GlobalData.game.add_child(explosion_particles)
	
	queue_free() # Remove the enemy node from the scene
