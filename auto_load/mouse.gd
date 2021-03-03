"""
mouse.gd
	Mainly for using mouse for camera and toggling it on and off
"""
extends Node
var toggle = true setget set_toggle
var capture = false setget set_capture
var sensitivity = 0.3
var motion = Vector2.ZERO
var motion_previous = Vector2.ZERO

func _process(_delta):
	if Input.is_action_just_pressed("toggle_mouse"):
		set_toggle(!toggle)
	if motion == motion_previous: 
		motion = Vector2.ZERO
	motion_previous = motion

func _input(event):
	if event is InputEventMouseButton:
		if not toggle and capture:
			set_toggle(true)
	
	elif capture and toggle:
		if event is InputEventMouseMotion:
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				motion = event.relative * sensitivity

func set_toggle(tog):
	toggle = tog
	if tog:
		if capture:
			capture_mouse()
	elif capture:
		show_mouse()

func set_capture(cap):
	capture = cap
	if cap:
		if toggle:
			capture_mouse()
	elif toggle:
		show_mouse()
	
func get_motion():
	return motion

func capture_mouse():
	if get_viewport() != null:
		get_viewport().warp_mouse(get_viewport().get_size()*.5)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		call_deferred("capture_mouse")

func show_mouse():
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
