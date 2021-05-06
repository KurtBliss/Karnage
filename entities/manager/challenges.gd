extends VBoxContainer
signal challenge_completed(msg)
var destroy_on_release = false
onready var challenges = [
	new_challenge($HS1000, "typeHS", 1000),
	new_challenge($HS750, "typeHS", 750),
	new_challenge($HS500, "typeHS", 500),
]

func _process(_delta):
	if destroy_on_release:
		if not Input.is_action_pressed("show_challenges"):
			queue_free()
	for challenge in challenges:
		if challenge == null:
			pass
		else:
			if not is_done(challenge["label"]):
				var result = call(challenge["method"], challenge)
				if result:
					emit_signal("challenge_completed", challenge["label"].get_text())

func new_challenge(_label, _type, _condition):
	return {
		"label": _label,
		"method": _type,
		"condition": _condition
	}

func typeHS(challenge):
	if is_instance_valid(Master.Player):
		if Master.Player.score >= challenge["condition"]:
			do_mark(challenge["label"])

func do_mark(node:Label):
	node.get_node("Crossout").visible = true

func is_done(node:Label):
	return node.get_node("Crossout").visible
