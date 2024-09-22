extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"/root/MusicPlayer".pitch_scale = 0.2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	return

# called when play button is pressed
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

# called when how to play button pressed
func _on_howtoplay_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/how_to_play.tscn")
