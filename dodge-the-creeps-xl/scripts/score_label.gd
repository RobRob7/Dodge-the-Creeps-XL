extends Label

# is called when mob is squashed so UI score can be incremented
func _on_mob_squashed():
	
	# play squashing sound
	$"/root/Hitmarker".play()
	
	# increment points counter
	Global.points += 1
	
	# update score text
	text = "Score: %s" % Global.points
