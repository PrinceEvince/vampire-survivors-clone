extends Node

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		UserData.save_user_data()
		get_tree().quit()
