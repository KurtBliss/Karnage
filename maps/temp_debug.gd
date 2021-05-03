extends Label

func _process(delta):
	var par : Enemy = get_parent()
	text = ""
#	if par.on_floor:

	text = "On Floor: " + String(par.is_on_floor())
	text += "\nPhysics_State: " + String(par.physics_state)
	text += "\nState: " + String(par.state)
	
