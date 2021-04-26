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
export var direction_offset = 90
var undamageable : bool = false
var velocity = Vector3.ZERO
var on_floor = false

func _ready():
	add_to_group("actor")

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

#TODO: process_velocity
func process_velocity(_delta):
	if not on_floor:
		velocity.y -= 1
	velocity = move_and_slide(velocity, Vector3.UP)
	velocity = velocity.linear_interpolate(Vector3.ZERO, 1.0)
	pass


func do_damage(dmg : float, from : Actor):
	if undamageable:
		return
#	health -= dmg

	print(name, " actor recived dmg: ", dmg)

	set_health(get_health() - dmg)
	
	if from:
		var method = "_on_attacked_from_" + from.name
		print("doing damage ", dmg)
		if has_method(method):
			call(method, dmg)
		
	if has_method("_on_attacked"):
		call("_on_attacked", dmg)

func state_reset(set_state, set_physics_state):
	set_state(set_state)
	set_physics_state(set_physics_state)

func state_return():
	state_reset(previous_state, previous_physics_state)


func lengthdir_x(dist, angle):
	return dist * cos( angle )

func lengthdir_y(dist, angle):
	return dist * -sin( angle )

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

