class_name NodeHelper
extends Object

static func create_timer(parent:Node,wait_time:float,one_shot:bool=false,autostart:bool=false,name:String = "Timer") -> Timer:
	var timer : Timer = Timer.new()
	timer.wait_time = wait_time
	timer.one_shot = one_shot
	timer.autostart = autostart
	timer.name = name
	parent.add_child(timer)
	return timer
