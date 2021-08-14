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
		label.text = str(set)
func get_label():
	return label_text
#func _process(delta):
#	if ref.is_valid(ref.player):
#		var lookat = ref.player.global_transform.origin
#		lookat.y = global_transform.origin.y # + 1
#		look_at(ref.player.global_transform.origin, Vector3.UP)
