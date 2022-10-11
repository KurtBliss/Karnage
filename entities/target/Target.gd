tool
class_name Target
extends StaticBody
export var text = "K" setget set_text

var wait_for_level = true

var hit = false

func _ready():
	if Engine.editor_hint:
		return
	
	$AnimationPlayer.play("spin")

func _process(delta):
	if Engine.editor_hint:
		return
	
	if ref.is_valid(ref.player):
		look_at(ref.player.global_transform.origin, Vector3.UP)
	
	if wait_for_level:
		if is_instance_valid(ref.level):
			wait_for_level = false
			ref.level.target_goal += 1

func _on_shot():
	if hit:
		return
	if is_instance_valid(ref.level):
		ref.level.target_gain()
		hit = true
		queue_free()
	
func set_text(txt):
	text = txt
	$Label3D.text = txt
