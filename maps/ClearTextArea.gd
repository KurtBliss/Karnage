extends Area

func _on_ClearTextArea_body_entered(body):
	if body is Player:
		queue_free()
