extends WeaponContainer

func _process(_delta):
#	if weapons.size() < 1:
#		return
	var can_input = Master.input_enabled()
	
	if is_instance_valid(current_weapon):
		if current_weapon.automatic:
			if Input.is_action_pressed("fire") and can_input:
				current_weapon.do_fire()
		else:
			if Input.is_action_just_pressed("fire") and can_input:
				current_weapon.do_fire()
		
		if Input.is_action_just_pressed("reload") and can_input:
			current_weapon.start_reload()

			
		if Input.is_action_pressed("hit") and can_input:
			throw_timer -= 1 # * delta * 60
			if throw_timer < 1:
				throw_weapon()
		else:
			throw_timer = 15
			
		if Input.is_action_just_pressed("hit") and can_input:
			var hit = false
			current_weapon.anime.seek(0)
			current_weapon.anime.play("Hit", -1, 2)
			if raycast_hit.is_colliding():
				var collider = raycast_hit.get_collider()
				if collider.is_in_group("Enemy"):
					collider.do_damage(5, holder, "Hit", {"stun": 100})
					hit = true
			holder.do_emit_hit(hit, current_weapon.name, -1, true)
		
	if Input.is_action_just_pressed("switch_weapon"):
		switch_weapon()
