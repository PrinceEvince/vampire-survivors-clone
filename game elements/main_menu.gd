extends Node2D

func _ready() -> void:
	UserData.save_user_data()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://game elements/game.tscn")

func _on_shop_pressed() -> void:
	get_tree().change_scene_to_file("res://game elements/shop.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
