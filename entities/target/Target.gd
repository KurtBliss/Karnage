class_name Target
extends StaticBody

func _on_shot():
	if is_instance_valid(ref.level):
		ref.level.target_gain()
		queue_free()
	
