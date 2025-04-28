extends Control


const TYPE_NEW_WEAPON = "new_weapon"
const TYPE_LVL_UP = "lvl_up"
const TYPE_XP_MULT = "xp_mult"
const TYPE_HP_RESTORE = "max_hp"
const TYPE_GIVE_GEMS = "give_gems"


class Upgrade:
	var type: String
	var value: Variant # Can be String (weapon name) or float (multiplier)
	var description: String
	var icon: Texture2D

	func _init(p_type: String, p_value: Variant, p_description: String, p_icon: Texture2D):
		self.type = p_type
		self.value = p_value
		self.description = p_description
		self.icon = p_icon


const XP_ORB_ICON = preload("res://assets/imgs/xp orb icon.png")
const HP_ICON = preload("res://assets/imgs/heart icon.png")
const GEM_ICON = preload("res://assets/imgs/gem icon.png")
const WEAPON_ICONS = {
	"firey sauce": preload("res://assets/imgs/firey sauce icon.png"),
	"spatula": preload("res://assets/imgs/spatula icon.png"),
	"pan": preload("res://assets/imgs/pan icon.png"),
	"knife weapon": preload("res://assets/imgs/knife icon.png")
}

@onready var buttons = [
	$NinePatchRect/HBoxContainer/VBoxContainer1/Button1,
	$NinePatchRect/HBoxContainer/VBoxContainer2/Button2,
	$NinePatchRect/HBoxContainer/VBoxContainer3/Button3
]

@onready var labels = [
	$NinePatchRect/HBoxContainer/VBoxContainer1/Label1,
	$NinePatchRect/HBoxContainer/VBoxContainer2/Label2,
	$NinePatchRect/HBoxContainer/VBoxContainer3/Label3
]

@onready var levelup_sound = $levelup
var upgrade_options: Array[Upgrade] = []


func _ready():
	levelup_sound.play()
	populate_options()
	global_position = GlobalData.player.global_position
	get_tree().paused = true


func populate_options():
	upgrade_options.clear()
	var generated_values = []
	for i in range(buttons.size()):
		var upgrade_data: Upgrade = generate_random_upgrade_data(generated_values)
		if upgrade_data:
			upgrade_options.append(upgrade_data)
			update_button_display(i, upgrade_data)
			if upgrade_data.type == TYPE_NEW_WEAPON or upgrade_data.type == TYPE_LVL_UP:
				generated_values.append(upgrade_data.value)
		else: # was sometimes having a weird bug so this is necessary
			printerr("Failed to generate upgrade option for button ", i)
			buttons[i].disabled = true
			labels[i].text = "N/A"


func generate_random_upgrade_data(exclude_values: Array) -> Upgrade:
	var random_number = randi_range(1, 100)


	if random_number <= 20 and not GlobalData.player.weapons_unowned.is_empty():
		var available_new = GlobalData.player.weapons_unowned.filter(func(w): return not w in exclude_values)
		if not available_new.is_empty():
			var weapon_name = available_new.pick_random()
			return Upgrade.new(
				TYPE_NEW_WEAPON,
				weapon_name,
				"New Weapon!",
				WEAPON_ICONS.get(weapon_name)
			)
	# weapon upgrade
	if random_number <= 70 and not GlobalData.player.weapons_owned.is_empty():
		var available_owned = GlobalData.player.weapons_owned.filter(func(w): return not w in exclude_values)
		if not available_owned.is_empty():
			var weapon_name = available_owned.pick_random()
			return Upgrade.new(
				TYPE_LVL_UP,
				weapon_name,
				"+1 Lvl",
				WEAPON_ICONS.get(weapon_name)
			)
	
	random_number = randi_range(1, 100)
	if random_number <= 50:
		return Upgrade.new(
			TYPE_XP_MULT,
			1.25,
			"x1.25 XP",
			XP_ORB_ICON
		)
		
	else:
		
		if GlobalData.player.max_hp == GlobalData.player.hp:
			return Upgrade.new(
				TYPE_GIVE_GEMS,
				3,
				"+3 Gems",
				GEM_ICON
			)
			
		else:
			return Upgrade.new(
				TYPE_HP_RESTORE,
				100,
				"Max HP!",
				HP_ICON
			)
		


func update_button_display(index: int, data: Upgrade):
	if index >= 0 and index < buttons.size():
		labels[index].text = data.description
		buttons[index].icon = data.icon
		buttons[index].disabled = false


func apply_upgrade(upgrade_data: Upgrade):
	match upgrade_data.type:
		TYPE_NEW_WEAPON:
			print("Adding weapon: ", upgrade_data.value)
			GlobalData.player.add_weapon(upgrade_data.value)
		TYPE_XP_MULT:
			print("Applying XP Multiplier: ", upgrade_data.value)
			pass
		TYPE_LVL_UP:
			print("Increasing level for: ", upgrade_data.value)
			pass
		TYPE_HP_RESTORE:
			print("Restoring player's HP")
			for num in range(1,100):
				GlobalData.player.gain_hp(1)
		TYPE_GIVE_GEMS:
			print("Giving 3 gems")
			UserData.gems += 3

	get_tree().paused = false
	queue_free()


func _on_button_1_pressed() -> void:
	if upgrade_options.size() > 0:
		apply_upgrade(upgrade_options[0])

func _on_button_2_pressed() -> void:
	if upgrade_options.size() > 1:
		apply_upgrade(upgrade_options[1])

func _on_button_3_pressed() -> void:
	if upgrade_options.size() > 2:
		apply_upgrade(upgrade_options[2])
