extends Area
export var msg_name = ""
var que = false
var trigger = false

func _on_TutorialPoint_body_entered(body):
	if not trigger:
		if not body is Player:
			return
		ref.tutorial._triggered_point(self)
		trigger = true
		visible = false
