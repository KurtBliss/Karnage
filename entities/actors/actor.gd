class_name Actor
extends KinematicBody



signal died()
signal injured(dmg, how)
signal health_changed(value)
signal physics_state_changed(func_name)
signal state_changed(func_name)
signal stuned()
signal unstuned()

export (int) var acceleration = 5
export (int) var speed = 10
export (float) var gravity = 1.8
export (int) var jump_power = 40
export (int) var injured_delay = 30 # Not in use?
export (int) var health = 100 setget set_health
export (float) var direction_offset = 90
var knockable = true

export onready var blood_decal = preload("res://entities/decals/BloodDecal.tscn")
onready var blood_effect = preload("res://entities/decals/blood.tscn")

export var actor_name = ""
var state = "" setget set_state, get_state
var physics_state = "" setget set_physics_state, get_physics_state
var previous_physics_state = "" 
var previous_state = ""
var previous_health = 0
var injured = 0 # Not in use?
var undamageable : bool = false
var velocity = Vector3.ZERO
var blood : CPUParticles
var blood_delay = 0
var ammo = Master.ammo_container
var stun = 0
var has_died = false
export var stun_limit = 80

func _ready():
	add_to_group("actor")
	var b = blood_effect.instance()
	add_child(b)
	blood = b

func _process(delta):
	if state != "" and has_method(state):
		call(state, delta)
	if global_transform.origin.y < -10:
		do_damage(1000, self)
		if actor_name != "Player":
			queue_free()
	if stun > 0:
		stun -= delta
	if stun >= stun_limit:
		emit_signal("stuned");
		if has_method("on_stuned"):
			call("on_stunned");
		stun = 0

func _physics_process(delta):
	if physics_state != "" and has_method(physics_state):
		call(physics_state, delta)

func set_health(value): 
	emit_signal("health_changed", value)
	previous_health = health
	health = value
	if (health < 0):
		if !has_died:
			emit_signal("died")
			has_died = true

func get_health(): 
	return health

func set_state(method): 
	emit_signal("state_changed", method)
	previous_state = state
	state = method
	if method != "" and !has_method(method): 
		print("state [" + method + "] does not exsist!")

func get_state(): 
	return state

func set_physics_state(method): 
	emit_signal("physics_state_changed", method)
	previous_physics_state = physics_state
	physics_state = method

func get_physics_state(): 
	return physics_state

func process_velocity(_delta):
	
	if blood_delay > 0:
		blood_delay -= _delta * 60
		if blood_delay <= 0:
			blood.emitting = false
	
	velocity.y -= gravity
	velocity = move_and_slide(velocity, Vector3.UP)
	velocity = velocity.linear_interpolate(Vector3.ZERO, 1.0)
	
	if has_method("update_step_check"):
		call("update_step_check")


func do_damage(dmg : float, from : Actor, how = "", etc = {}):
	if how == "":
		how = "unkown"
	emit_signal("injured", dmg, how)
	if undamageable:
		return
	var alive = get_health() > 0
	set_health(get_health() - dmg)
	if etc.has("stun"):
		stun += etc["stun"]
	else:
		stun += dmg / 3
	if etc.has("knock") and knockable:
		move_and_slide(etc["knock"].normalized() * 100, Vector3.UP)
		prints("Knock=", etc["knock"])
	var method = "_on_attacked"
	if alive and get_health() <= 0:
		method += "_killed"
	if has_method(method):
		call(method, dmg)
	if from:
		if from.actor_name == "":
			print_debug("Check this...")
		method += "_from_" + from.actor_name
		if has_method(method):
			call(method, dmg, how)
			


func state_reset(set_state, set_physics_state):
	set_state(set_state)
	set_physics_state(set_physics_state)

func state_return():
	state_reset(previous_state, previous_physics_state)


func lengthdir_x(dist, angle):
	return dist * cos( angle )

func lengthdir_y(dist, angle):
	return dist * -sin( angle )

func set_direction(set):
	rotation_degrees.y = set

func get_direction():
	return wrap(rotation_degrees.y + direction_offset, 0, 359)

func get_facing_vector():
	return Vector3(lengthdir_x(1, get_direction()), 0, lengthdir_y(1, get_direction()) ).normalized()

func angle_difference(ang0, ang1):
	return ((((ang0 - ang1) % 360) + 540) % 360) - 180;

func wrap(value, _min, _max):
	_min = int(floor(_min))
	_max = int(floor(_max))
	value = int(floor(value))
	var _mod = ( value - _min ) % ( _max - _min )
	if ( _mod < 0 ): 
		return _mod + _max 
	else: 
		return _mod + _min

