class_name Screen_Options
extends Screen
onready var but_fullscreen : Menu_Button = $VBoxContainer/HBoxContainer/VBoxContainer/FullScreen
onready var but_keep : Menu_Button = $VBoxContainer/HBoxContainer/VBoxContainer/Keep
onready var but_mute : Menu_Button = $VBoxContainer/HBoxContainer/VBoxContainer/Mute
onready var but_volume : HSlider = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/HSlider

func _ready() -> void:
	fullscreen_check_update()
	keep_check_update()
	mute_check_update()
	volume_check_update()

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

func mute_pressed(button : Menu_Button) -> void:
	GameSettings.opt_mute_toggle()
	mute_check_update()

func mute_check_update():
	but_mute.set_check_box(GameSettings.opt_mute_get())

func volume_check_update():
	but_volume.value = GameSettings.opt_volume_get()

func _on_HSlider_drag_ended(value_changed):
	pass # Replace with function body.


func _on_HSlider_value_changed(value):
	GameSettings.opt_volume_set($VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/HSlider.value)
