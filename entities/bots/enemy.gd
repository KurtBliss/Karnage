class_name Enemy
extends Bot

var zigzag = 0
var zigzag_offset = Vector3.ZERO
var zigzag_dist_stop = 6
var zigzag_dist_start = 16
var offdirzig
var offdirzag
var enemy_atk_delay_set = 30
var enemy_atk_delay = 0
var wait_for_player = true

onready var starting_origin = transform.origin

enum {ZIG, ZAG}

func _ready():
	set_physics_state("state_idle")
	add_to_group("Enemy")
	
func _process(_delta):
	var p = get_player()
	if wait_for_player:
		if p:
			p.connect("fired", self, "_on_fired")
			p.connect("died", self, "_on_player_died")
			print("connecting to player's fire signal... ")
			wait_for_player = false
			print("Got player")
	elif p:
		enemy_atk_delay -= 1
		if get_player_distance() < 7 and enemy_atk_delay<=0:
			p.do_damage(7,self)
			enemy_atk_delay = enemy_atk_delay_set

func state_idle(_delta):
	if Input.is_action_pressed("debugEnemy"):
			# 45 degree turn
			# switch state
			do_walk()
	if not get_player():
		return
	if get_player_spotted():
		print("delay state change!")
		delay_state_change(2.0, "", "state_chase")
#		yield(get_tree().create_timer(1.0), "timeout")
#		set_physics_state("state_chase")

func state_alert(_delta):
	pass

func state_chase(_delta):
	$Arms/AnimeHands.play("Walk")
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
	if get_player_visibility():
		set_physics_state("state_chase")
		return
	var process = process_path()
	if not process:
		set_path_to_player()


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
		print("zag")
	else:
		zigzag = ZIG
		switch_zig_zag()
		timer_zig_zag()
		print("zig")

func _on_fired():
	set_physics_state("state_chase")

func on_alterted():
	print("on_alterted")
	if get_physics_state() == "state_idle":
		set_physics_state("state_alert")

func _on_Enemy_died():
	get_player().score += 10
	var ld = load("res://entities/bots/EnemySpawn.tscn")
	var inst = ld.instance()
	inst.transform.origin = starting_origin
	inst.spawn_scene_location = filename
	Master.GameWorld.add_child(inst)
	queue_free()

func _on_attacked_from_Player(dmg : float = 5):
	on_alterted()
	
func _on_player_died():
	wait_for_player = true
