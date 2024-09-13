extends Label

var score = 0

# is called when mob is squashed so UI score can be incremented
func _on_mob_squashed():
	score += 1
	text = "Score: %s" % score
