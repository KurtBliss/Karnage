extends AudioStreamPlayer3D

func _on_AudioStreamPlayer3DImpact_finished():
	queue_free()
