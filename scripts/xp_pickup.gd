extends Pickup

func give_player_stuff():
	GlobalData.player.gain_xp(1)
	print('giving xp')
