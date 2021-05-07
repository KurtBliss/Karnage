extends Area

export var ques = false

func _on_Area_body_entered(body):
	if body is Player:
		queue_free()
