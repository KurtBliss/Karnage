class_name ChallengeLabel
extends Label
onready var crossout = $Crossout
var done = false setget set_done

func set_name(set):
	text = set

func set_done(set = false):
	done = set
	if set:
		crossout.visible = true
	else:
		crossout.visible = false

