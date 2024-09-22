extends Node

@export var mob_scene: PackedScene

# path to .ini file
var save_path := "user://player_score.ini"

func _ready() -> void:
	# check if ini file already present
	if(FileAccess.file_exists(Global.save_path)):
		print("File Found")
	else:
		Global.set_high_score(0)
	
	# hide the retry UI
	$UserInterface/Retry.hide()
	# set the high score label
	Global.load(save_path)
	$UserInterface/HighScoreLabel.text = "High Score: %d" % Global.get_high_score()

func _on_mob_timer_timeout() -> void:
	
	# create new instance of Mob scene
	var mob = mob_scene.instantiate()
	
	# choose random location on SpawnPath and store
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	
	# give mob_spawn_location random offset
	mob_spawn_location.progress_ratio = randf()
	
	# mob spawn on same Y position as player
	mob_spawn_location.position.y = -1
	
	# get player position
	var player_position = $Player.position
	
	# initialize mob position depending on player position
	mob.initialize(mob_spawn_location.position, player_position)
	
	# spawn the mob in main scene
	add_child(mob)
	
	# connect the mob to the score label to update the score upon squashing one
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())

# is called when player is hit by mob
func _on_player_hit() -> void:
	
	# play jumpscare sound for player death
	$"/root/PlayerDeath".play()
	
	# stop the mob timer
	$MobTimer.stop()
	
	# set the new high score
	Global.set_high_score(Global.points)
	
	# reset current points to zero
	Global.points = 0
	
	# show the retry screen
	$UserInterface/Retry.show()
	
# is called when any input is pressed
func _unhandled_input(event: InputEvent) -> void:
	
	# only reset when button pressed and the retry option is visible on UI
	if event.is_action_pressed("enter") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()

# is called when player selects quit button
func _on_quit_to_main_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")
