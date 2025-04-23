extends Node2D



func _ready():
	$FryCook/FryCookAnim.play("idle")
	$Chef/ChefAnim.play("idle")
	if UserData.frycook == true:
		$FryCook/FryCookSprite.texture = load("res://assets/imgs/frycook_gray.png")
		$FryCook/FryCookButton.text = "Equipped"
	if UserData.chef == true:
		$Chef/ChefSprite.texture = load("res://assets/imgs/chef_gray.png")
		$Chef/ChefButton.text = "Equipped"

func _process(delta: float) -> void:
	$GemCount.text = "Gems: " + str(UserData.gems)

func _on_fry_cook_button_pressed() -> void:
	if UserData.frycook_purchased == false:
		if UserData.gems >= 15:
			#This buys the frycook skin for the first time
			equip_frycook()
			unequip_chef()
			UserData.gems -= 15
			UserData.frycook_purchased = true
		else:
			$NotEnoughGems.show()
			$Timer.start()
	elif UserData.frycook_purchased == true:
		equip_frycook()
		unequip_chef()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/shop.tscn")
	
func equip_chef():
	$Chef/ChefButton.text = "Equipped"
	$Chef/ChefSprite.texture = load("res://assets/imgs/chef_gray.png")
	UserData.chef = true

func unequip_chef():
	$Chef/ChefButton.text = "Equip"
	$Chef/ChefSprite.texture = load("res://assets/imgs/chef.png")
	UserData.chef = false

func equip_frycook():
	$FryCook/FryCookSprite.texture = load("res://assets/imgs/frycook_gray.png")
	$FryCook/FryCookButton.text = "Equipped"
	UserData.frycook = true
	
func unequip_frycook():
	$FryCook/FryCookSprite.texture = load("res://assets/imgs/frycook.png")
	$FryCook/FryCookButton.text = "Equip"
	UserData.frycook = false


func _on_timer_timeout() -> void:
	$NotEnoughGems.hide()


func _on_chef_button_pressed() -> void:
	if UserData.chef == false:
		equip_chef()
		unequip_frycook()
