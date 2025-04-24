extends Node2D



func _ready():
	$FryCook/FryCookAnim.play("idle")
	$Chef/ChefAnim.play("idle")
	$CoolGuy/CoolGuyAnim.play("idle")
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
			if UserData.chef == true:
				unequip_chef()
			if UserData.coolguy == true:
				unequip_coolguy()
			UserData.gems -= 15
			UserData.frycook_purchased = true
		else:
			$NotEnoughGems.show()
			$Timer.start()
	elif UserData.frycook_purchased == true:
		equip_frycook()
		if UserData.chef == true:
			unequip_chef()
		if UserData.coolguy == true:
			unequip_coolguy()


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

func equip_coolguy():
	$CoolGuy/CoolGuySprite.texture = load("res://assets/imgs/coolguy_gray.png")
	$CoolGuy/CoolGuyButton.text = "Equipped"
	UserData.coolguy = true
	
func unequip_coolguy():
	$CoolGuy/CoolGuySprite.texture = load("res://assets/imgs/coolguy.png")
	$CoolGuy/CoolGuyButton.text = "Equip"
	UserData.coolguy = false

func _on_timer_timeout() -> void:
	$NotEnoughGems.hide()

func _on_chef_button_pressed() -> void:
	if UserData.chef == false:
		equip_chef()
		if UserData.frycook == true:
			unequip_frycook()
		if UserData.coolguy == true:
			unequip_coolguy()


func _on_cool_guy_button_pressed() -> void:
	if UserData.coolguy_purchased == false:
		if UserData.gems >= 50:
			#This buys the frycook skin for the first time
			equip_coolguy()
			if UserData.chef == true:
				unequip_chef()
			if UserData.frycook == true:
				unequip_frycook()
			UserData.gems -= 50
			UserData.coolguy = true
			UserData.coolguy_purchased = true
		else:
			$NotEnoughGems.show()
			$Timer.start()
	elif UserData.coolguy_purchased == true:
		equip_coolguy()
		if UserData.chef == true:
			unequip_chef()
		if UserData.frycook == true:
			unequip_frycook()
