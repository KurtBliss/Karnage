"""

	MOUSE MOTION SCRIPT (dynamic)
	
"""
extends Node
class_name Mouse
var sensitivity = 0.3
var motion = Vector2.ZERO
var motionPrevious = Vector2.ZERO
var caller = null
var callback = null

func _init(_speed, _caller, _callback):
	caller = _caller
	sensitivity = _speed
	callback = _callback
	capture_mouse()

func _process(delta):
	if Input.is_action_just_pressed("toggle_mouse"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			capture_mouse()
	if motion == motionPrevious: motion = Vector2.ZERO
	else: 
		if caller != null && caller.has_method(callback):
			caller.call(callback, motion, delta)
		motionPrevious = motion

func _input(event):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			motion = event.relative * sensitivity


func capture_mouse():
	print_stack()
	print("capturing mouse")
	print(get_viewport())
	if get_viewport() != null:
		get_viewport().warp_mouse(get_viewport().get_size()*.5)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		call_deferred("capture_mouse")
