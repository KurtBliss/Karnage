extends Label

func _process(delta):
	var par : Enemy = get_parent()
	text = "is_on_floor=false"
	if par.on_floor:
		text = "is_on_floor=true"
	
