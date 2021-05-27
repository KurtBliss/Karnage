class_name Goomba
extends Enemy

var zigzag = 0
var zigzag_offset = Vector3.ZERO
var zigzag_dist_stop = 6
var zigzag_dist_start = 16
var offdirzig
var offdirzag
var bodies = ["wait"]
var set_fire_delay = 3
var cur_fire_delay = set_fire_delay
var vec_look_at = Vector3.ZERO

var stick_to_path = false
enum {ZIG, ZAG}

var died = false
onready var mixamo = $Mannequin/Anime
onready var raycast = $RayCast
onready var weapon : WeaponContainer = $Mannequin/Skeleton/BoneAttachment/Weapon

func _ready():
	#speed *= 1.3
	$SwitchMask.play("normal")
	set_physics_state("state_idle")

func state_idle(_delta):
	mixamo.play("Idle")
	
	if not get_player():
		return
	if get_player_spotted():
		set_physics_state("state_chase")
#		delay_state_change(2.0, "", "state_chase")
	process_path()
#		yield(get_tree().create_timer(1.0), "timeout")
#		set_physics_state("state_chase")

func state_dumb(_delta):
	pass

func state_alert(_delta):
	pass

func do_aim():
	set_physics_state("state_aim")
	mixamo.play("Aim")
	do_face_player()
	vec_look_at = -global_transform.basis.z

func state_aim(delta):
	cur_fire_delay -= delta 
	
	var prev_rot = rotation
	look_at(global_transform.origin + vec_look_at, Vector3.UP)
	var new_y = rotation.y
	rotation = prev_rot
	rotation.y = new_y
#	linear_interpolate(vector, rate)

	var p : Player = get_player()
	if p:
		var dir =  p.global_transform.origin - global_transform.origin 
		vec_look_at+=dir.normalized()*10
		vec_look_at.normalized()
		
		print(vec_look_at)
	
	if cur_fire_delay <= 0:
		print_debug("Fire")
		if weapon.current_weapon:
			weapon.current_weapon.do_fire()
		cur_fire_delay = set_fire_delay
		do_aim()

func state_chase(_delta):
	if process_chase_step():
		return
	mixamo.play("Walk")
	if get_player_visibility():
		if get_player_distance() < 20:
			cur_fire_delay = set_fire_delay
			do_aim()
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

func state_chase_zig_zag(_delta):
	if process_chase_step():
		return
	
	mixamo.play("Walk")
	
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
	mixamo.play("Walk")
	
	
	if get_player_visibility() and not stick_to_path:
		set_physics_state("state_chase")
		return
	
	var process = process_path()
	if not process:
		set_path_to_player()


func state_dead(_delta):
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

func _on_Enemy_died():
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
