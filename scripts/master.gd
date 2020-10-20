"""

	MASTER SCRIPT
	
"""
extends Node
var Player

func _process(_delta):
	if Input.is_action_just_pressed("game_end"):
		get_tree().quit()
	OS.set_window_title("Karnage " + str(Engine.get_frames_per_second()))

