class_name Screen
extends Control
export(NodePath) onready var np_button_container
onready var button_container = get_node(np_button_container)
var scene_path_to_load
onready var FadeIn : FadeIn = $FadeIn

func _ready():
	var has_focus = false
	for button in button_container.get_children():
		
		if not has_focus:
			has_focus = true
			button.grab_focus()
			
		var _result = button.connect("pressed", self, "_on_Button_pressed", [button])
		_result = button.connect("mouse_entered", self, "_on_mouse_entered", [button])
		
#	FadeIn.connect("fade_finished", self, "_on_FadeIn_fade_finished")
	
#[button.scene, button.method]
func _on_Button_pressed(button):
	var method = button.method
	var path = button.scene
	if method.replace(" ", "") == "":
		scene_path_to_load = path
		FadeIn.show()
		FadeIn.fade_in()
	else:
		call(method, button)

func _on_mouse_entered(button):
	button.grab_focus()

func _on_FadeIn_fade_finished():
	var _status = get_tree().change_scene(scene_path_to_load)
	
