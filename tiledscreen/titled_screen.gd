extends Control

#todo: ahh

var scene_path_to_load

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Menu/CenterRow/Buttons/New.grab_focus()
	for button in $Menu/CenterRow/Buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene])
		print(button.scene)

func _on_Button_pressed(path):
	scene_path_to_load = path
	$FadeIn.show()
	$FadeIn.fade_in()

func _on_FadeIn_fade_finished():
	get_tree().change_scene(scene_path_to_load)
	pass # Replace with function body.
