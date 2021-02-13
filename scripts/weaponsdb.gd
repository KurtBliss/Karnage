extends Node

onready var db = {
	"none": new_weapon("", "none"),
	"Pistol": new_weapon("Pistol", "Pistol")
}

func get_weapon_db(_weapon_name):
	if db[_weapon_name] != null:
		return db[_weapon_name]

func has_weapon_db(_weapon_name): #works?
	for weapon in db:
		if weapon["name"] == _weapon_name:
			return true
	return false

func new_weapon(_path, _name, _clip_size = -1, _clip_cur = -1, _has = true):
	return {
		path = _path,
		weapon = _name,
		clip_size = _clip_size,
		clip_cur = _clip_cur,
		has = _has,
	}
