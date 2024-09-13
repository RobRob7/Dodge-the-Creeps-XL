extends CharacterBody3D

# emitted when player jumps on a mob
signal squashed

# min speed of mob in m/s
@export var min_speed = 10

# max speed of mob in m/s
@export var max_speed = 18

func _physics_process(delta: float) -> void:
	move_and_slide()

# will be called from main scene
func initialize(start_position, player_position):
	
	# place mob at start_position and rotate towards player_position (mob looks at player)
	look_at_from_position(start_position, player_position, Vector3.UP)
	
	# rotate mob randomly (-45 deg to +45 deg range) towards player
	rotate_y(randf_range(-PI / 4, PI / 4))
	
	# calculate random speed
	var random_speed = randi_range(min_speed, max_speed)
	
	# calculate forward velocity
	velocity = Vector3.FORWARD * random_speed
	
	# rotate velocity vector based on mob's Y rotation
	velocity = velocity.rotated(Vector3.UP, rotation.y)

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()

# will be called when mob is squashed by player
func squash():
	squashed.emit()
	queue_free()
