extends Node
# master.gd

var Player # Init on player _ready()
var Manager # Init on manager _ready()
var GameWorld # Init on Nav _ready()
var GameTimer # Init on GameTimer _ready()

func _process(_delta):
	if Input.is_action_just_pressed("game_end"):
		get_tree().quit()
		return
	OS.set_window_title("Karnage " + str(Engine.get_frames_per_second()))
	
	if Input.is_action_just_pressed("mute"):
		print("mute")
#		AudioServer.set_stream_global_volume_scale(0)

#		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
#		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)


func debug_enemy():
	return Input.is_action_just_pressed("debugEnemy")

