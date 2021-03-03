"""

	Stick Script
	Set input deadzone to 0 for best accuracy

"""
extends Node
class_name Stick
var sensitivity = 5
var motion = Vector2.ZERO
var motionPrevious = Vector2.ZERO
var caller = null
var callback = null
var right = null
var left = null
var up = null
var down = null
var deadzone = null
var multiplier = null

func _init(_controls, _speed: float, _caller: Node, _callback: String, _deadzone: float = 0.25, _multiplier: float = 1.25): 
	left = _controls[0]
	right = _controls[1]
	up = _controls[2]
	down = _controls[3]
	caller = _caller
	sensitivity = _speed
	callback = _callback
	deadzone = _deadzone
	multiplier = _multiplier

func _process(delta):
	motionPrevious = motion
	var hor = Input.get_action_strength(right) - Input.get_action_strength(left)
	var ver = Input.get_action_strength(down) - Input.get_action_strength(up)
	
	if deadzone > 0.2:
		if abs(hor) < .15: hor = 0
		if abs(ver) < .15: ver = 0

	if abs(hor) > deadzone or abs(ver) > deadzone:
		var mspd = max(abs(hor), abs(ver))
		var spd = mspd * sensitivity * (mspd * multiplier)
		motion = Vector2(hor, ver).normalized() * spd
	else:
		motion = Vector2.ZERO
	
	if motion!=Vector2.ZERO: 
		if caller != null && caller.has_method(callback):
				caller.call(callback, motion, delta)
	
