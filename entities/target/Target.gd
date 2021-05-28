class_name Target
extends StaticBody

var wait_for_level = true

var hit = false

func _process(delta):
	
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
	
