extends Control

# called when user selects I understand button
func _on_backtomenu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")
