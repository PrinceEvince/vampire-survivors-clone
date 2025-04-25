extends Label

func _ready():
	text = "Gems gained this run: " + str(UserData.gems)
