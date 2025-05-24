extends AudioStreamPlayer

func _ready():
	var songs = [preload("res://game elements/music/battlemusic (2).mp3"), preload("res://game elements/music/thatsa spicy meatball.mp3")]
	stream = songs.pick_random()
	play()
