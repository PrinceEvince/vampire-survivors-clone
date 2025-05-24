extends Node2D



func _on_upgrades_pressed() -> void:
	pass # Replace with function body.


func _on_skins_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/skin_shop.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
