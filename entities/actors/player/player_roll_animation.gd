extends AnimationPlayer

func roll_animation(rot: Vector3, z_dir, x_dir):
	if is_playing():
		return
		
	playback_speed = 1.45

	var side = true if abs(z_dir) < abs(x_dir) else false
	var sideanime = get_animation("rollside") if x_dir > 0 else get_animation("roll left")
	var frontanime = get_animation("roll") if z_dir < 0 else get_animation("roll back")
	var anime = sideanime if side else frontanime
	
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
			return 1
		elif x_dir < 0:
			play("roll left")
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
			play("roll back")
			return 1
	return 0

func lean_animation(rot:Vector3, pos:Vector3,  left:bool, backwards:bool):
	var anime : Animation
	
	if left: 
		anime = get_animation("leanleft")
	else:
		anime = get_animation("leanright")
	
	var xx = rot.x
	var yy = rot.y
	var zz = rot.z
	var key1 = anime.track_find_key(0, 0, true)
	var key2 = anime.track_find_key(0, 1, true)
	var key1_x = anime.track_find_key(1, 0, true)
	var key2_x = anime.track_find_key(1, 1, true)
	
	var vect = Vector3(xx, yy, 0)	
	vect.z =anime.track_get_key_value(0, key1).z
	anime.track_set_key_value(0, key1, vect)
	vect.z =anime.track_get_key_value(0, key2).z
	anime.track_set_key_value(0, key2, vect)
	
	var vect_x = Vector3(0, pos.y, pos.z)
	vect_x.x =anime.track_get_key_value(1, key1_x).x
	anime.track_set_key_value(1, key1_x, vect_x)
	vect_x.x =anime.track_get_key_value(1, key2_x).x
	anime.track_set_key_value(1, key2_x, vect_x)
	
	if left:
		play("leanleft", -1, 2)
	else:
		play("leanright", -1, 2)
	if backwards:
		play_backwards(current_animation, -1)
		playback_speed = 2
	
