extends Node
# master.gd

var Player # Init on player _ready()
var Manager # Init on manager _ready()

func _process(_delta):
	if Input.is_action_just_pressed("game_end"):
		get_tree().quit()
	OS.set_window_title("Karnage " + str(Engine.get_frames_per_second()))

func debug_enemy():
	return Input.is_action_just_pressed("debugEnemy")
