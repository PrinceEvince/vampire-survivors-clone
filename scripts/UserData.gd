extends Node

var chef: bool = true
var frycook: bool = false
var frycook_purchased = false
var coolguy: bool = false
var coolguy_purchased = false
var gems: int = 0
var SAVE_PATH = "res://save data/save.json"

func _ready():
	load_user_data()


func load_user_data():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	var data = json.get_data()
	if data is Dictionary:
		self.frycook_purchased = data.get("frycook purchased", false)
		self.coolguy_purchased = data.get("coolguy purchased", false)
		self.gems = data.get("gems", 0)
		print("Successfully loaded data from: ", SAVE_PATH)

	
func save_user_data(): # run this when the game closes or maybe in between lives
	print("saving!")
	print(gems)
	var data_to_save = {"frycook purchased": frycook_purchased, "coolguy purchased": coolguy_purchased, "gems": gems}
	var json_string = JSON.stringify(data_to_save)
	var file = FileAccess.open("res://save data/save.json", FileAccess.WRITE)
	file.store_string(json_string)
