class_name Target
extends StaticBody

var wait_for_level = true

func _process(delta):
	if wait_for_level:
		if is_instance_valid(ref.level):
			wait_for_level = false
			ref.level.target_goal += 1

func _on_shot():
	if is_instance_valid(ref.level):
		ref.level.target_gain()
		queue_free()
	
