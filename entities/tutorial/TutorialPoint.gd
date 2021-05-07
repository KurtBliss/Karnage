extends Area
export var msg_name = ""
export var que = false
var trigger = false

func _on_TutorialPoint_body_entered(body):
	if not trigger:
		if not body is Player:
			return
		Master.Tutorial._triggered_point(self)
	else:
		trigger = true
		visible = false
