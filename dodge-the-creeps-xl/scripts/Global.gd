extends Node

# path to .ini file
var save_path := "res://player_score.ini"

# current points when playing
var points = 0

# current high score
var high_score = 0

# bool to determine whether player has read how to or not
var has_read_how_to = false

# set the new high score (if valid) in .ini
func set_high_score(value):
	if(value > Global.high_score):
		save(value)

# get the current high score in .ini
func get_high_score():
	return high_score

# to load data
func load(save_path) -> void:
	var config_file := ConfigFile.new()
	var error := config_file.load(save_path)

	if error:
		print("An error happened while loading data: ", error)
		return
	
	high_score = config_file.get_value("Player", "points", 0)

# to save data
func save(value) -> void:
	var config_file := ConfigFile.new()

	config_file.set_value("Player", "points", value)

	var error := config_file.save(save_path)
	if error:
		print("An error happened while saving data: ", error)
