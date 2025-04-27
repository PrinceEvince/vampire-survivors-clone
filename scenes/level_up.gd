extends Control

var existing_weapons = ["firey sauce", "spatula", "frying pan", "knife"]

func randomly_generate_options():
	var random_number = randi_range(1,100)	
	
	if random_number in range(1,10):
		var random_new_weapon = GlobalData.player.weapons_unowned.get_random()
	
	if random_number in range(11,70):
		var random_existing_weapon = GlobalData.player.weapons_owned.get_random()

func _on_button_1_pressed() -> void:
	pass # Replace with function body.


func _on_button_2_pressed() -> void:
	pass # Replace with function body.


func _on_button_3_pressed() -> void:
	pass # Replace with function body.
