class_name Actor
extends KinematicBody
# actor.gd

signal died()
signal injured()
signal health_changed(value)
signal physics_state_changed(func_name)
signal state_changed(func_name)

export (int) var acceleration = 5
export (int) var speed = 10
export (float) var gravity = 0.98
export (int) var jump_power = 30
export (int) var injured_delay = 30 # Not in use?
var health = 100 setget set_health
var state = "" setget set_state, get_state
var physics_state = "" setget set_physics_state, get_physics_state
var previous_physics_state = "" 
var previous_state = ""
var previous_health = 0
var injured = 0 # Not in use?

func _process(delta):
	if state != "" and has_method(state):
		call(state, delta)

func _physics_process(delta):
	if physics_state != "" and has_method(physics_state):
		call(physics_state, delta)

func set_health(value): 
	emit_signal("health_changed", value)
	previous_health = health
	health = value
	if (health < 0):
		emit_signal("died")
	elif (health < previous_health):
		emit_signal("injured")

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

func do_damage(dmg : float, from : Actor):
#	health -= dmg
	set_health(get_health() - dmg)
	var method = "_on_attacked_from_" + from.name
	print("doing damage ", dmg)
	if has_method(method):
		call(method, dmg)
	elif has_meta("_on_attacked"):
		call("_on_attacked", dmg)

func state_reset(state, physics_state):
	set_state(state)
	set_physics_state(physics_state)

func state_return():
	state_reset(previous_state, previous_physics_state)
