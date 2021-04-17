class_name Screen_Options
extends Screen

onready var but_fullscreen : Menu_Button = $VBoxContainer/HBoxContainer/VBoxContainer/FullScreen

func _ready() -> void:
	fullscreen_check_update()

func fullscreen_pressed(button : Menu_Button) -> void:
	GameSettings.opt_fullscreen_toggle()
	fullscreen_check_update()

func fullscreen_check_update():
	but_fullscreen.set_check_box(GameSettings.opt_fullscreen_get())
