extends Node2D

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_mainmenu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
