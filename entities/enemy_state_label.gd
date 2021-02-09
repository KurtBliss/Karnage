extends Label

var string = ""

func _process(_delta):
	var par = get_parent()
	
	if par.get_player():
		append(["ps: ", par.physics_state])
		append(["Dist: ", floor(par.get_player_distance())])
		append(["Start: ", par.zigzag_dist_start])
		append(["Stop: ", par.zigzag_dist_stop])
		append(["zigzag: ", par.zigzag])
		append(["eps: ", par.get_position()])
		append(["pps: ", par.get_player_position()])
		append(["off: ", par.zigzag_offset])
		
		
		
	set_text(string)
	string = ""
	

func append(new_var = null, new_line = true):
	if new_var != null:
		if typeof(new_var) == TYPE_ARRAY:
			for cur_var in new_var:
				append(cur_var, false)
		else:
			string += str(new_var)
	if new_line:
		string += "\n"
