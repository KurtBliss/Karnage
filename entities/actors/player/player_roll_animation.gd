extends AnimationPlayer

func roll_animation(rot: Vector3, z_dir, x_dir):
	if is_playing():
		return
		
	playback_speed = 1.45

	var side = true if abs(z_dir) < abs(x_dir) else false
	var anime = get_animation("rollside") if side else get_animation("roll")
	var key1 = anime.track_find_key(0, 0, true)
	var key2 = anime.track_find_key(0, 0.5, true)
	var key3 = anime.track_find_key(0, 1, true)
	var xx = rot.x
	var yy = rot.y
	var zz = rot.z

	if side:
		var vect = Vector3(xx, yy, 0)	
		vect.z =anime.track_get_key_value(0, key1).z
		anime.track_set_key_value(0, key1, vect)
		vect.z =anime.track_get_key_value(0, key2).z
		anime.track_set_key_value(0, key2, vect)
		vect.z =anime.track_get_key_value(0, key3).z
		anime.track_set_key_value(0, key3, vect)
		if x_dir > 0:
			play("rollside")
			print_debug("rollside")
			return 1
		elif x_dir < 0:
#			play_backwards("rollside")
			play("roll left")
			print_debug("roll left")
			
			return -1
	else:
		var vect = Vector3(0, yy, zz)
		vect.x =anime.track_get_key_value(0, key1)[0]
		anime.track_set_key_value(0, key1, vect)
		vect.x =anime.track_get_key_value(0, key2)[0]
		anime.track_set_key_value(0, key2, vect)
		vect.x =anime.track_get_key_value(0, key3)[0]
		anime.track_set_key_value(0, key3, vect)
		if z_dir < 0:
			play("roll")
			
			return -1
		elif z_dir > 0:
#			play_backwards("roll")
			play("roll back")
			return 1
	return 0
