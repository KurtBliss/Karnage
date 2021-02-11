extends Node

onready var db = {
	"none": new_weapon("", "none"),
	"Pistol": new_weapon("Pistol", "Pistol")
}

func new_weapon(path, name, clip_size = -1, clip_cur = -1, has = false):
	return {
		has = false,
		path = "",
		clip_cur = -1,
		clip_size = -1
	}
