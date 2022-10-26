class_name Goomba
extends Enemy

var zigzag = 0
var zigzag_offset = Vector3.ZERO
var zigzag_dist_stop = 6
var zigzag_dist_start = 16
var offdirzig
var offdirzag
var bodies = ["wait"]
var set_fire_delay = 1.5
var cur_fire_delay = set_fire_delay
var vec_look_at = Vector3.ZERO
var pickup
var do_pickup = 0

var stick_to_path = false
enum {ZIG, ZAG}

var died = false
onready var mixamo = $Mannequin/Anime
onready var ch36 = $Mannequin/Skeleton/Ch36
onready var raycast = $RayCast
onready var weapon : WeaponContainer = $Mannequin/Skeleton/BoneAttachment/Weapon
onready var label : Label3D = $Label3D


var point_ld = preload("res://entities/unit/Point.tscn")
var points = []

func set_path_to(target_pos):
	.set_path_to(target_pos)
	
	for point in points:
		if is_instance_valid(point):
			point.queue_free()
	
	for point in path:
		var inst = point_ld.instance()
		get_parent().add_child(inst)
		inst.global_transform.origin = point
		points.append(inst)

func process_path():
	if path_ind < path.size():
		var pathpoint : Vector3 = path[path_ind]
		var curpos = $Feet.global_transform.origin 
		var move_vec = (pathpoint - curpos + Vector3(0, y_offset, 0))
		if move_vec.length() < 1:
			path_ind += 1
		else:
			var dir = move_vec.normalized() * speed
			look_at(Vector3(pathpoint.x, global_transform.origin.y, pathpoint.z), Vector3.UP)
			velocity = dir
		return true
	return false
	

func _ready():
	$SwitchMask.play("normal")
	set_physics_state("state_idle")
	$Hit.play("default")


func _process(delta : float) -> void:
	label.text = str(get_physics_state())
	if $Feet.get_collider():
		global_transform.origin.y += 0.2
	if do_pickup > 0:
		do_pickup -= 1
	._process(delta)

func state_idle(_delta):
	mixamo.play("Idle")
	if not get_player():
		return
	if get_player_spotted():
		set_physics_state("state_chase")
	process_path()
	start_grab_weapon()

func state_dumb(_delta):
	pass

func state_alert(_delta):
	pass

func start_stun():
	set_physics_state("state_stunned")
	$Stunned.play("Stunned")
#	if weapon != null and is_instance_valid(weapon) and weapon.get_children().size() > 0:
#		weapon.throw_weapon()

func state_stunned(_delta):
	pass

func do_aim():
	set_physics_state("state_aim")
	mixamo.play("Aim")
	do_face_player()

func state_aim(delta):
	cur_fire_delay -= delta 
	
	if !get_player_visibility():
		set_physics_state("state_chase")
	
	var p : Player = get_player()
	if p:
		var player_pos = p.global_transform.origin
		
		var previous_rot = rotation
		look_at(player_pos,Vector3.UP)
		var rotation_y = wrapf(rotation.y,-PI,PI)
		rotation = previous_rot
		rotation.y = wrapf(rotation.y,-PI,PI)
		
		var dif = rotation_y - rotation.y
		if dif < -PI:
			rotation_y+= TAU
		if dif > PI:
			rotation_y-= TAU
		var absdif = abs(rotation_y - rotation.y)
		
		enemy_tween.interpolate_property(self,"rotation:y",rotation.y,rotation_y,absdif * 1.3,Tween.TRANS_LINEAR)
		enemy_tween.start()
		yield(enemy_tween,"tween_completed")
	
	if cur_fire_delay <= 0:
		if weapon.current_weapon:
			weapon.current_weapon.do_fire()
		cur_fire_delay = set_fire_delay
		do_aim()

func state_chase(_delta):
	if process_chase_step():
		return
	mixamo.play("Walk")
	start_grab_weapon()	
	
	if !$Footsteps.playing:
		$Footsteps.play()
	if get_player_visibility():
		if get_player_distance() < 20:
			if weapon != null and is_instance_valid(weapon) and weapon.get_children().size() > 0:
				cur_fire_delay = set_fire_delay
				do_aim()
				$Footsteps.stop()
				return
		do_chase_player()
		if get_player_distance() > zigzag_dist_start:
			switch_zig_zag()
			set_physics_state("state_chase_zig_zag")
	else:
		set_path_to_player()
		set_physics_state("state_chase_path")

func switch_zig_zag():
	if !get_player():
		return
	offdirzig  = wrap(get_player_direction()-100, 0, 359)
	offdirzag = wrap(get_player_direction()+100, 0, 359)
	timer_zig_zag()
	start_grab_weapon()	
	if !$Footsteps.playing:
		$Footsteps.play()

func state_chase_zig_zag(_delta):
	start_grab_weapon()	
	
	if process_chase_step():
		return
	mixamo.play("Walk")
	
	if !$Footsteps.playing:
		$Footsteps.play()
	
	if not get_player_visibility():
		set_path_to_player()
		set_physics_state("state_chase_path")
		return
	if get_player_distance() < zigzag_dist_stop:
		set_physics_state("state_chase")
		return
	var offset_len = min(17, get_player_distance(zigzag_offset))
	if zigzag == ZAG:
		zigzag_offset = Vector3(lengthdir_x(offset_len, offdirzig), 0, lengthdir_y(offset_len, offdirzig))
	elif zigzag == ZIG:
		zigzag_offset = Vector3(lengthdir_x(offset_len, offdirzag), 0, lengthdir_y(offset_len, offdirzag))
	do_chase_player(null, zigzag_offset)

func state_chase_path(_delta):
	start_grab_weapon()	
	
	mixamo.play("Walk")
	
	if !$Footsteps.playing:
		$Footsteps.play()
	
	if get_player_visibility() and not stick_to_path:
		set_physics_state("state_chase")
		return
	
	var process = process_path()
	if not process:
		set_path_to_player()

func state_grab_weapon(_delta):
	
	if not is_instance_valid(pickup):
		set_physics_state(previous_physics_state)
		return
	
	var process = process_path()
	if not process:
		set_path_to_node(pickup)
		
	if path_ind == path.size() \
	and $PickupTimer.is_stopped():
		$PickupTimer.start()
	

func start_grab_weapon(within_range = 15):
	if weapon.get_child_count() > 0:
		return
	
	var wpn = get_closest_pickup_weapon(within_range)
	if wpn != null:
#		if get_node_spotted(wpn):
			pickup = wpn
			set_path_to_node(pickup)
			set_physics_state("state_grab_weapon")

func get_closest_pickup_weapon(within_range = 300):
	var weapons = get_tree().get_nodes_in_group("weapon_pickup")
	var dist
	var closest
	var closest_dist
	for wpn in weapons:
		dist = (global_transform.origin - wpn.global_transform.origin)
		dist = dist.length()
		if closest == null or dist < closest_dist:
			closest = wpn
			closest_dist = dist 
	if  weapons.size() > 0\
	and closest_dist > within_range:
		return null
	return closest

func state_dead(_delta):
	$Footsteps.stop()
	pass

func update_step_check():
	var pos = Vector3(velocity.x, -1, velocity.z)
	$StepCheck.rotation = velocity.normalized()

func process_chase_step():
	if not process_step_check():
		stick_to_path = true
		set_path_to_player()
		set_physics_state("state_chase_path")
		return true
	return false

func process_step_check():
	if bodies.has("wait"):
		return true
	if bodies.size() == 0:
		return false
	return true

func timer_zig_zag():
	var name = "__bot_zig_zag_timer"
	var timer : Timer
	if not has_node(name):
		timer = Timer.new()
		timer.name = name
		add_child(timer)
		timer.autostart = true
		timer.wait_time = 2.5
		var _connect = timer.connect("timeout", self, "_timeout_zig_zag")
	timer = get_node(name)
	timer.start()

func _timeout_zig_zag():
	if health > 0:
		if zigzag == ZIG: 
			zigzag = ZAG
			switch_zig_zag()
			timer_zig_zag()
		else:
			zigzag = ZIG
			switch_zig_zag()
			timer_zig_zag()

#func _on_fired():
#	if get_physics_state() == "state_idle":
#		set_physics_state("state_chase")

func on_alterted():
	if get_physics_state() == "state_idle":
		set_physics_state("state_alert")

func on_stunned():
	pass

func _on_Enemy_died():
	
	for point in points:
		if is_instance_valid(point):
			point.queue_free()
	
	var hp_ld = preload("res://entities/pickups/Health.tscn")
	add_child(hp_ld.instance())
	
	$Hit.play("dead")
	if not died:
		died = true
		if respawn == true:
			var ld = load("res://entities/actors/enemies/EnemySpawn.tscn")
			var inst = ld.instance()
			inst.transform.origin = starting_origin
			inst.spawn_scene_location = filename
			ref.level.add_child(inst)
		
		weapon.throw_weapon()
		
		mixamo.play("Death")
		$Particles.emitting = true
		drain_player_on_proximity = false
		set_physics_state("state_dead")
		$Particles.emitting = false
		$CollisionShape.disabled = true
		$CollisionShapeDeath.disabled = false
		$SwitchMask.play("dead")
		
		$deathTimer.start()
#	queue_free()

func _on_deathTimer_timeout():
	$Particles.emitting = false
	if not GameSettings.opt_keep_get():
		queue_free()

func _on_switch_switched(on):
	if on and health > 0 and get_physics_state() == "state_idle":
		set_physics_state("state_chase")

func _on_StepCheck_body_entered(body):
	bodies.append(body)
	var wait = bodies.find("wait")
	if wait != -1:
		bodies.remove(wait)
	if get_physics_state() == "":
		set_physics_state("state_idle")

func _on_StepCheck_body_exited(body):
	var f = bodies.find(body)
	if f != -1:
		bodies.remove(f)

func _on_Stunned_animation_finished(anim_name):
	if get_health() > 0:
		state_reset("","")
		set_physics_state("state_chase")

func _on_Goomba_stuned():
	if get_health() > 0:
		if get_physics_state() != "state_stunned":
			start_stun()
			stun = 0
			weapon.throw_weapon()

func _on_Goomba_injured(dmg, how):
	if get_health() > 0:
	
		$Hit.play("hit")
		$Hit.seek(0, true)
		if get_physics_state() == "state_stunned": # and how == "Hit"
			weapon.throw_weapon()


func _on_Goomba_died():
	_on_Enemy_died()


func _on_PickupTimer_timeout():
	do_pickup = 3
	pass # Replace with function body.
