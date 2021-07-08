tool
class_name Label3d
extends Spatial
export(String) var label_text = "" setget set_label,get_label
onready var label = $Viewport/Label
func _ready():
	label.text = label_text
func set_label(set):
	label_text = set
	if label != null and is_instance_valid(label):
		label.text = set
func get_label():
	return label_text
