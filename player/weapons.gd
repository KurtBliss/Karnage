class_name PlayerWeapons
extends Spatial

var weapons = []
onready var raycast = $RayLong
onready var raycast_hit = $RayShort

func _ready():
	$Pistol.visible = true
	if WeaponsDB != null:
		weapons.append(WeaponsDB.db["Pistol"])

func _process(_delta):
	handle_pistol()
	pass

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

func switch_weapon(wpn = 0):
	pass
