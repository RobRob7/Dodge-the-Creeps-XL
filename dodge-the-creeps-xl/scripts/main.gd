extends Node

@export var mob_scene: PackedScene

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

# is called when player is hit by mob
func _on_player_hit() -> void:
	$MobTimer.stop()
