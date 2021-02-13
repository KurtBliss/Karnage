extends Node

onready var db = {
	"none": new_weapon("none"),
	"Pistol": new_weapon("Pistol", "res://entities/pickups/PistolPickup.tscn")
}

func get_weapon_db(_weapon_name):
	if db[_weapon_name] != null:
		return db[_weapon_name]

func has_weapon_db(_weapon_name): #works?
	for weapon in db:
		if weapon["name"] == _weapon_name:
			return true
	return false

func new_weapon(_name, _pickup : = null, _clip_size = null, _clip_cur = null, _has = true):
	return {
		weapon = _name,
		pickup = _pickup,
		clip_size = _clip_size,
		clip_cur = _clip_cur,
		has = _has,
	}
