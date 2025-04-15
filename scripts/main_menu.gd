extends Node2D

var root = get_parent()
var game = preload("res://scenes/game.tscn")

func _on_button_pressed() -> void:
	root.add_child(game)
	queue_free()
