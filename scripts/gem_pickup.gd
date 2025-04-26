extends Pickup

func _ready():
	add_to_group("pickups")
	print('gem spawned')
	%AnimationPlayer.play("idle")

func give_player_stuff():
	UserData.gems += 1
	
