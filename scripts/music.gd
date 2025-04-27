extends AudioStreamPlayer

func _ready():
	var songs = [preload("res://assets/audio/battlemusic (2).mp3"), preload("res://assets/audio/thatsa spicy meatball.mp3")]
	stream = songs.pick_random()
	play()
