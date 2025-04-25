extends Pickup

func _ready():
	add_to_group("pickups")
	%AnimationPlayer.play("idle")

func give_player_stuff():
	UserData.gems += 1
