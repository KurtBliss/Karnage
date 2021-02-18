extends VBoxContainer

var done_color = "a6ff08"

var challenges = {
	
}

var new_challenge = {
	
}

func _process(delta):
	if Master.Player == null:
		return
	
	
	
	var p = Master.Player
	if p.score >= 1000:
		pass #set color to done_color
	
	
	
