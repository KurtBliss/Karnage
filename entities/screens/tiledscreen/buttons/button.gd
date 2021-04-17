tool
class_name Menu_Button
extends Button

onready var label = $Label
onready var checkbox = $Label/CheckBox

export(String, FILE, "*.tscn") var scene = "res://menus/TitledScreen.tscn"

export(String) var method = ""

export(String) var label_text = "" setget label_text_set

export(bool) var show_check = false

func label_text_set(text) -> void:
	label_text = text
	if label:
		label.text = text
	else:
		pass
#		print("missing label...")


func _ready():
	label_text_set(label_text)
	if show_check:
		show_check_box()
	

func show_check_box() -> void:
	checkbox.visible = true

func set_check_box(check : bool):
	checkbox.pressed = check
