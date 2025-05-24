extends AudioStreamPlayer

func _ready():
	var songs = [preload("res://assets/audio/music/battlemusic (2).mp3"), preload("res://assets/audio/music/thatsa spicy meatball.mp3")]
	stream = songs.pick_random()
	play()
