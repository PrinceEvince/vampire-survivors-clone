extends Node
class_name SFXController

var sfx: Dictionary = {}

func _ready():
	
	for sound in get_children():
		print(sound)
		var node_name = sound.get_name()
		sfx[node_name] = sound
	print(sfx)
	
func play_sfx(sfx_name: String):
	var sound_to_play = sfx[sfx_name]
	sound_to_play.play()
	pass
	
	
