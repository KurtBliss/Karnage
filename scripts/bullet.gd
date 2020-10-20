extends Position3D

func _on_Area_body_entered(body: Bot):
	if body==null or body.name==null: 
		return
	if body.is_in_group("Zombie"):
		body.health -= 10
	else:
		return null
