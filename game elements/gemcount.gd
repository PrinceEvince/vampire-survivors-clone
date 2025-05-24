extends Label

func _ready():
	text = "Total Gems: " + str(UserData.gems)
