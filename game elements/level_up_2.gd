extends PanelContainer

var button_texture_map = {
	"res://assets/imgs/buttons/fireysauce.png": "res://assets/imgs/buttons/fireysauce_dark.png",
	"res://assets/imgs/buttons/heart.png": "res://assets/imgs/buttons/heart_dark.png",
	"res://assets/imgs/buttons/knife.png": "res://assets/imgs/buttons/knife_dark.png",
	"res://assets/imgs/buttons/pan.png": "res://assets/imgs/buttons/pan_dark.png",
	"res://assets/imgs/buttons/spatula.png": "res://assets/imgs/buttons/spatula_dark.png",
	"res://assets/imgs/buttons/xp.png": "res://assets/imgs/buttons/xp_dark.png"
}

@onready var upgradecontainer1 = %VBoxContainer
@onready var upgradecontainer2 = %VBoxContainer2
@onready var upgradecontainer3 = %VBoxContainer3

var button_keys: Array

func _ready():
	
	for key in button_texture_map:
		button_keys.append(key)
		
	update_container(upgradecontainer1)
	update_container(upgradecontainer2)
	update_container(upgradecontainer3)
	pass
	
func update_container(container_to_update):
		var picked_button = button_keys.pick_random()
		var picked_button_img = Image.load_from_file(picked_button)
		var picked_button_texture = ImageTexture.create_from_image(picked_button_img)
		
		var picked_button_hover = button_texture_map.get(picked_button)
		print(picked_button_hover)
		var picked_hover_img = Image.load_from_file(picked_button_hover)
		var picked_hover_texture = ImageTexture.create_from_image(picked_hover_img)
		
		for child in container_to_update.get_children():
			if child is TextureButton:
				child.texture_normal = picked_button_texture
				child.texture_hover = picked_hover_texture
			else:
				continue
