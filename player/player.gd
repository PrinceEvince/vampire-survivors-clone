extends CharacterBody2D

@export var speed = 200
@onready var camera = $Camera2D  # Assuming the Camera2D node is a child of the player
var previous_global_position = global_position
var mouse_position
var direction = Vector2.ZERO
@onready var ani_player = %AnimationPlayer
@onready var sprite = %Sprite2D
var xp = 0
@export var xp_mult = 1
@export var level: int = 1
@export var base_xp_requirement: int = 50
@export var xp_scaling_factor: float = 7.0
var health_drop_chance_numerator: int = 1
@export var health_drop_chance_denominator: int = 5
var gem_drop_chance_numerator: int = 1
@export var gem_drop_chance_denominator: int = 5
@export var exponent: float = 1.5
var current_xp: int = 0
var xp_needed: int = 0
@onready var xp_bar = %xp_bar

@export var max_hp = 10
@export var hp = 10
@onready var health_bar = %health_bar
var bodies_entered = []
var active_hurt_tween: Tween
@export var hurt_color = Color(1.0, 0.5, 0.5)  # Reddish tint for hurt effect
@export var normal_color = Color(1.0, 1.0, 1.0) # Default modulate is usually white
@export var hurt_effect_duration = 0.15 # Total time for the flash (flash on + flash off)
@export var invincible = false



#Mob Spawn Path
@onready var mobspawner = %MobSpawner
@onready var spawnerpicker = %SpawnLocationPicker


@export var starting_weapon = "pan"
var owned_weapons = [starting_weapon]
const KNIFE_WEAPON_SCENE = preload("res://weapons/knife/knife_weapon.tscn")
const PAN_SCENE = preload("res://weapons/pan/pan.tscn")
const FIREY_SAUCE_SCENE = preload("res://weapons/firey sauce/firey_sauce.tscn")
const SPATULA_SCENE = preload("res://weapons/spatula/spatula.tscn")
var all_weapons = {"knife weapon": KNIFE_WEAPON_SCENE, "pan": PAN_SCENE, "firey sauce": FIREY_SAUCE_SCENE, "spatula": SPATULA_SCENE}
var weapons_unowned = ["knife", "pan", "firey sauce", "spatula"]
var weapons_owned = {}


func _ready():
	GlobalData.player = self
	var temp_weapons = ["knife weapon", "pan", "spatula", "firey sauce"]
	if starting_weapon in temp_weapons:
		temp_weapons.erase(starting_weapon)
	weapons_unowned = temp_weapons
	add_weapon(starting_weapon)
	
	level = 1
	xp_needed = calculate_xp_to_next_lvl(level)
	xp_bar.max_value = xp_needed
	
	health_bar.value = 10

	if UserData.chef == true:
		%Sprite2D.texture = load("res://assets/imgs/chef.png")
	if UserData.frycook == true:
		%Sprite2D.texture = load("res://assets/imgs/frycook.png")
	if UserData.coolguy == true:
		%Sprite2D.texture = load("res://assets/imgs/coolguy.png")

func _process(_delta):
	if len(bodies_entered) > 0:
		if not invincible:
			lose_hp(1)
			invincible = true
			$iFrames.start()

func _physics_process(_delta):
	var input_dir = Input.get_vector("a", "d", "w", "s")
	velocity = input_dir * speed
	move_and_slide()
	mouse_position = get_global_mouse_position()
	
	var presses = 0
	#this animation controller is shit and needs to be changed at some point lol
	
	if Input.is_action_pressed("a") and presses < 1:
		ani_player.play("walk_left")
		presses += 1
	if Input.is_action_pressed("d") and presses < 1:
		ani_player.play("walk_right")
		presses += 1
	if Input.is_action_pressed("s") and presses < 1:
		ani_player.play("walk_down")
		presses += 1
	if Input.is_action_pressed("w") and presses < 1:
		ani_player.play("walk_up")
		presses += 1
	
func add_weapon(weapon: String):
	print("adding weapon: "+weapon)
	var new_weapon = all_weapons[weapon].instantiate()
	weapons_owned[weapon] = new_weapon
	weapons_unowned.erase(weapon)
	self.add_child(new_weapon)

func get_closest_enemy():
	if len(get_tree().get_nodes_in_group("enemies")) == 0:
		return null
	else:
		var closest_enemy_distance = INF
		var closest_enemy_reference = Node2D
		for enemy in get_tree().get_nodes_in_group("enemies"):
			var distance = global_position.distance_to(enemy.global_position)
			if distance < closest_enemy_distance:
				closest_enemy_distance = distance
				closest_enemy_reference = enemy
		return closest_enemy_reference
		

func get_highest_hp_enemy_nearby(radius: float):
	var enemies_in_group = get_tree().get_nodes_in_group("enemies")
	if len(enemies_in_group) == 0:
		return null
	else:
		var highest_hp_found = 0
		var highest_hp_reference = null
		for enemy in get_tree().get_nodes_in_group("enemies"):
			if enemy.global_position.distance_to(global_position) <= radius:
				if highest_hp_found < enemy.HEALTH:
					highest_hp_found = enemy.HEALTH
					highest_hp_reference = enemy
		return highest_hp_reference
			

func calculate_xp_to_next_lvl(level: int):
	if level < 1:
		return base_xp_requirement
	var xp_needed_float: float = base_xp_requirement + pow(level * xp_scaling_factor, exponent)
	var xp_needed: int = int(floor(xp_needed_float))
	if xp_needed < 1:
		xp_needed = 1
	return xp_needed
	
func lose_hp(dmg: int):
	hp -= dmg
	health_bar.value = hp
	active_hurt_tween = create_tween()
	active_hurt_tween.tween_property(sprite, "modulate", hurt_color, hurt_effect_duration / 2.0)
	active_hurt_tween.tween_property(sprite, "modulate", normal_color, hurt_effect_duration / 2.0)
	if hp <= 0:
		get_tree().change_scene_to_file("res://scenes/deathscreen.tscn")

func gain_hp(amt):
	if max_hp == hp:
		pass
	else:
		hp += amt
		health_bar.value = hp

func gain_xp(amt: int):
	current_xp += amt * xp_mult
	xp_bar.value = current_xp
	while current_xp >= xp_needed:
		level_up()
		

func level_up():
	level += 1
	var sfx_player = AudioStreamPlayer.new()
	sfx_player.stream = preload("res://assets/audio/levelup.mp3")
	sfx_player.volume_db = -9
	sfx_player.play()
	current_xp -= xp_needed
	xp_needed = calculate_xp_to_next_lvl(level)
	%LevelLabel.text = "Current level: " + str(level)
	xp_bar.value = 0
	xp_bar.max_value = xp_needed
	
	const LEVEL_UP_SCENE = preload("res://scenes/LevelUp.tscn")
	GlobalData.game.add_child(LEVEL_UP_SCENE.instantiate())
	get_tree().paused = true


func _on_lvlupdebug_pressed() -> void:
	gain_xp(xp_needed)


func _on_takedmgdebug_pressed() -> void:
	lose_hp(1)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		bodies_entered.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	bodies_entered.erase(body)


func _on_i_frames_timeout() -> void:
	invincible = false
	
