extends Position3D
# bullet.gd

func _on_Area_body_entered(body):
	if body==null or body.name==null: 
		return
	if body.is_in_group("Zombie"):
		body.health -= 10
	else:
		return null
