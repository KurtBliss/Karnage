extends KinematicBody

func _physics_process(delta):
	physics_idle(delta)

func physics_idle(_delta):
	if is_instance_valid(ref.player):
		var prev_rot = rotation
		look_at(ref.player.global_transform.origin, Vector3.UP)	
		var rot = rotation
		rotation = prev_rot.linear_interpolate(rot, 0.1)
	pass

