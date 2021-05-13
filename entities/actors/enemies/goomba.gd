class_name Goomba
extends Enemy

var zigzag = 0
var zigzag_offset = Vector3.ZERO
var zigzag_dist_stop = 6
var zigzag_dist_start = 16
var offdirzig
var offdirzag
enum {ZIG, ZAG}

var died = false
onready var AnimeHands = $Arms/AnimeHands
onready var mixamo = $Mannequin/Anime

func _ready():
	speed *= 1.3
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

func state_chase(_delta):
	AnimeHands.play("Walk")
	mixamo.play("Walk")
	if get_player_visibility():
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
	
	if get_player_visibility():
		set_physics_state("state_chase")
		
		return
		
	var process = process_path()
	if not process:
		set_path_to_player()


func state_dead(_delta):
	pass

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
		
		
		mixamo.play("Death")
		$Particles.emitting = true
		drain_player_on_proximity = false
		set_physics_state("state_dead")
		$Particles.emitting = false
		$CollisionShape.disabled = true
		$CollisionShapeDeath.disabled = false
		
		$deathTimer.start()
#	queue_free()


func _on_deathTimer_timeout():
	$Particles.emitting = false
	if not GameSettings.opt_keep_get():
		queue_free()
