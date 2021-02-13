class_name PlayerWeapons
extends Spatial

var current = -1
var weapons = []
onready var raycast = $"../RayLong"
onready var raycast_hit = $"../RayShort"

func _ready():
	hide_all()

func _process(_delta):
	if weapons.size() < 1:
		return
	if weapons[current]["weapon"] == "Pistol" and weapons[current]["has"]:
		handle_pistol()
	if Input.is_action_just_pressed("test"):
		weapons.remove(current)
		current = -1
		hide_all()
		#spawn weapons pickup
		

func add_weapon(_weapon_name):
	weapons.append(WeaponsDB.get_weapon_db("Pistol"))

func has_weapon(_weapon_name):
	for weapon in weapons:
		if weapon["name"] == _weapon_name:
			return true
	return false

func handle_pistol():
	if Input.is_action_just_pressed("fire"):
		$Pistol/Anime.seek(0)
		$Pistol/Anime.play("Fire", -1, 2)
		$Pistol/Flash.visible = true
		emit_signal("fired")
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider.is_in_group("Enemy"):
				collider.do_damage(15, self)
			elif collider.is_in_group("DeathSpawn"):
				collider.hit()

	if Input.is_action_just_pressed("hit"):
		$Pistol/Anime.seek(0)
		$Pistol/Anime.play("Hit", -1, 2)
		if raycast_hit.is_colliding():
			var collider = raycast_hit.get_collider()
			if collider.is_in_group("Enemy"):
				collider.do_damage(5, self)

func hide_all():
	$Pistol.visible = false

func switch_weapon_by_name(_weapon_name : String):
	var id = -1
	for weapon in weapons:
		id += 1
		print(weapons)
		if weapon["weapon"] == _weapon_name:
			switch_weapon_by_id(id)
			return true
	return false

func switch_weapon_by_id(wpn : int = 0):
	hide_all()
	match weapons[wpn]["weapon"]:
		"Pistol": 
			if weapons[wpn]["has"]:
				$Pistol.visible = true
				current = wpn
