extends Label3D

func _process(delta):
	text = str(get_parent().path_ind)
