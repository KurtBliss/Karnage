class_name Screen_Options
extends Screen

onready var but_fullscreen : Menu_Button = $VBoxContainer/HBoxContainer/VBoxContainer/FullScreen

onready var but_keep : Menu_Button = $VBoxContainer/HBoxContainer/VBoxContainer/Keep

func _ready() -> void:
	fullscreen_check_update()
	keep_check_update()

func fullscreen_pressed(button : Menu_Button) -> void:
	GameSettings.opt_fullscreen_toggle()
	fullscreen_check_update()

func fullscreen_check_update():
	but_fullscreen.set_check_box(GameSettings.opt_fullscreen_get())

func keep_pressed(button : Menu_Button) -> void:
	GameSettings.opt_keep_toggle()
	keep_check_update()

func keep_check_update():
	but_keep.set_check_box(GameSettings.opt_keep_get())
