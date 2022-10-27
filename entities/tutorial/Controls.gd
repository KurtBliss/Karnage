class_name Controls
extends Label

const fm = {
	"MOVE": "WASD",
	"SHOOT": "Left Mouse",
	"RELOAD": "R",
	"MELEE": "Right Mouse",
	"PICKUP": "F",
	"SWITCH": "Tab",
	"ROLL": "Shift",
	"JUMP": "Spacebar"
}

func _ready():
	text = text.format(fm)
