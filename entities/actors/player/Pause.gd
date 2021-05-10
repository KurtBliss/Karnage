class_name Screen_Pause
extends Screen

func _ready():
	if get_tree().paused == false:
		visible = false

func game_end(_button) -> void:
	get_tree().quit()

func continue_game(_but) -> void:
	unpause()

func exit_level(_but) -> void:
	unpause(false)
	get_tree().change_scene("res://entities/screens/tiledscreen/titled_screen.tscn")

func _process(delta):
	if Input.is_action_just_pressed("game_end"):
		if get_tree().paused:
			unpause()
		else:
			pause()

func pause():
	get_tree().paused = true
	visible = true
	Mouse.set_capture(false)
	$VBoxContainer/Continue.grab_focus()

func unpause(mouse_capture = true):
	get_tree().paused = false
	visible = false
	Mouse.set_capture(mouse_capture)
	
