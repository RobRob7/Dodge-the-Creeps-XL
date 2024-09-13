extends CharacterBody3D

# emitted when player is hit by mob
signal hit

# the speed of the player in m/s
@export var speed = 14

# downward acceleration when in the air in m/s
@export var fall_acceleration = 75

# vertical impulse applied to character when jumping, in m/s
@export var jump_impulse = 20

# vertical impulse applied to character upon bouncing over a mob, in m/s
@export var bounce_impulse = 16

var target_velocity = Vector3.ZERO

func _physics_process(delta: float) -> void:
	
	# stores the input direction
	var direction = Vector3.ZERO
	
	# check for input and update direction accordingly
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	
	# check for player moving
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# basis property affects the rotation of the node
		$Pivot.basis = Basis.looking_at(direction)
		$AnimationPlayer.speed_scale = 4
	# check for player not moving
	else:
		$AnimationPlayer.speed_scale = 1
		
	# ground velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# jumping
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	
	# vertical velocity (gravity)
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	# iterate through all collisions that occurred this frame
	for index in range(get_slide_collision_count()):
		
		# get one of the collisions with the player
		var collision = get_slide_collision(index)
		
		# check for collision with ground
		if collision.get_collider() == null:
			continue
			
		# check for collider with mob
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			
			# check when we are hitting mob from above
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				
				# squash mob and bounce
				mob.squash()
				target_velocity.y = bounce_impulse
				
				# prevent further duplicate calls
				break
				
	
	# move character
	velocity = target_velocity
	move_and_slide()
	
	# make player arc when jumping
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse

# will be called when player dies
func die():
	hit.emit()
	queue_free()

# will be called when player is hit by mob
func _on_mob_detector_body_entered(body: Node3D) -> void:
	die()
