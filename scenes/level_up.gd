extends Control

var icons = {"xp orb": ImageTexture.create_from_image(Image.load_from_file("res://assets/imgs/xp orb icon.png")), "firey sauce": ImageTexture.create_from_image(Image.load_from_file("res://assets/imgs/firey sauce icon.png")), "spatula": ImageTexture.create_from_image(Image.load_from_file("res://assets/imgs/spatula icon.png")), "pan": ImageTexture.create_from_image(Image.load_from_file("res://assets/imgs/pan icon.png")), "knife weapon": ImageTexture.create_from_image(Image.load_from_file("res://assets/imgs/knife icon.png"))}

# These are stored so that when the button is pressed
# we know what exactly is stored in that button so we
# can give the player the appropriate upgrade/unlock/etc
var button_1_upgrade_type: String
var button_1_value: String
var button_2_upgrade_type: String
var button_2_value: String
var button_3_upgrade_type: String
var button_3_value: String
var upgrade_info1
var upgrade_info2
var upgrade_info3

func _ready():
	$levelup.play()
	populate_options()
	global_position = GlobalData.player.global_position

func populate_options():
	# upgrade_info: [upgrade_type: String, value: String]
	upgrade_info1 = randomly_generate_option("1")
	upgrade_info2 = randomly_generate_option("2")
	upgrade_info3 = randomly_generate_option("3")
	
func randomly_generate_option(num):
	var button = get_node("NinePatchRect/HBoxContainer/VBoxContainer"+num+"/Button"+num)
	var label = get_node("NinePatchRect/HBoxContainer/VBoxContainer"+num+"/Label"+num)
	
	var random_number = randi_range(1,100)	
	
	if random_number in range(1,10):
		label.text = "New weapon!"
		var random_new_weapon = GlobalData.player.weapons_unowned.pick_random()
		button.icon = icons[random_new_weapon]
		var upgrade_info = [label.text, random_new_weapon]
		return upgrade_info
		
	if random_number in range(11,70):
		label.text = "+1 Damage"
		var random_existing_weapon = GlobalData.player.weapons_owned.pick_random()
		button.icon = icons[random_existing_weapon]
		var upgrade_info = [label.text, random_existing_weapon]
		return upgrade_info
			
	if random_number in range(71, 100):
		label.text = "x1.25 XP"
		button.icon = icons["xp orb"]
		var upgrade_info = [label.text, "1.25"]
		return upgrade_info

func button_pressed(num):
	print("button pressed")
	var upgrade_info = null
	if num == 1:
		upgrade_info = upgrade_info1
	elif num == 2:
		upgrade_info = upgrade_info2
	else:
		upgrade_info = upgrade_info3
	if upgrade_info[0] == "New weapon!":
		GlobalData.player.add_weapon(upgrade_info[1])
	elif upgrade_info[0] == "x1.25 XP":
		pass # this upgrade does nothing rn
	elif upgrade_info[0] == "+1 Damage":
		pass # this upgrade does nothing rn
	get_tree().paused = false
	queue_free()

func _on_button_1_pressed() -> void:
	print("signal gaming")
	button_pressed(1)

func _on_button_2_pressed() -> void:
	print("signal gaming")
	button_pressed(2)

func _on_button_3_pressed() -> void:
	print("signal gaming")
	button_pressed(3)
