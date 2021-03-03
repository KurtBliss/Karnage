extends Node
# master.gd

var Player # Init on player _ready()
var Manager # Init on manager _ready()
var GameWorld # Init on Nav _ready()
var GameTimer # Init on GameTimer _ready()
var mute = false

func _process(_delta):
	if Input.is_action_just_pressed("game_end"):
		if Mouse.toggle and Mouse.capture:
			Mouse.set_toggle(false)
		else:
			get_tree().quit()
	
	OS.set_window_title("Karnage " + str(Engine.get_frames_per_second()))
	
	if Input.is_action_just_pressed("mute"):
		mute = !mute
		var bus_index = AudioServer.get_bus_index("Master")
		AudioServer.set_bus_mute(bus_index, mute)
