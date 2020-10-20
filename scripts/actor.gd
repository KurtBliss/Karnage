"""

	ACTOR SCRIPT
	
"""
extends KinematicBody
class_name Actor
export (int) var acceleration = 5
export (int) var speed = 10
export (float) var gravity = 0.98
export (int) var jump_power = 30

""" Health (SetGet) """
var health = 100 setget set_health
var previous_health = 0
signal set_health(value)

func set_health(value): 
	emit_signal("set_health", value)
	previous_health = health
	health = value
	if (health < 0):
		if has_method("_death"):
			call("_death")
	elif (health < previous_health):
		if has_method("_injured"):
			call("_injured")
			
func get_health(): return health


""" 
	Processes 
"""
func _process(delta):
	if state != "" and has_method(state):
		call(state, delta)
		
func _physics_process(delta):
	if physics_state != "" and has_method(physics_state):
		call(physics_state, delta)


""" 
	State Management 
"""
func state_reset(state, physics_state):
	set_state(state)
	set_physics_state(physics_state)

func state_return():
	state_reset(previous_state, previous_physics_state)

""" State (Set/Get) """
var state = "" setget set_state, get_state
var previous_state = ""
signal set_state(func_name)

func set_state(method): 
	emit_signal("set_state", method)
	previous_state = state
	state = method
	if method != "" and !has_method(method): 
		print("state [" + method + "] does not exsist!")
		
func get_state(): 
	return state

""" Physics State (Set/Get) """
var physics_state = "" setget set_physics_state, get_physics_state
var previous_physics_state = "" 
signal set_physics_state(func_name)

func set_physics_state(method): 
	emit_signal("set_physics_state", method)
	previous_physics_state = physics_state
	physics_state = method
	if method != "" and !has_method(method): 
		print("physics_state [" + method + "] does not exsist!")
	
func get_physics_state(): return physics_state
