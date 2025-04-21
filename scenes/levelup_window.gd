extends AcceptDialog

var Knife
var Spatula

func _ready():
	var ok_button = get_ok_button()
	ok_button.hide()
	
	Spatula = add_button("Unlock Spatula", false, "unlock_spatula")
	Knife = add_button("Unlock Knife", false, "unlock_knife")
