extends Label

func _ready():
	var fm = {
		"MOVE": "WASD",
		"SHOOT": "Left Mouse",
		"RELOAD": "R",
		"MELEE": "Right Mouse",
		"PICKUP": "E",
		"SWITCH": "Tab",
		"ROLL": "Shift",
		"JUMP": "Spacebar"
	}
	
	Input
	
	#TODO: Make controls screen dynamic
	text = text.format(fm)
