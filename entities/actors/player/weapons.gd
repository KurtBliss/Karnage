class_name PlayerWeapons
extends Spatial

var current = -1
var weapons = []
var throw_timer = 60*2
onready var raycast = $"../RayLong"
onready var raycast_hit = $"../RayShort"
onready var Pistol = $Pistol
onready var PistolAnime = $Pistol/Anime
onready var PistolCock = $Pistol/Cock

func _ready():
	hide_all()

func _process(_delta):
	if weapons.size() < 1:
		return
	if weapons[current]["weapon"] == "Pistol" and weapons[current]["has"]:
		handle_pistol()

func throw_weapon():
	#spawn
	var cur = get_current_weapon()
	if cur == null:
		return
	print(cur)
	var ld = load(cur["pickup"])
	var inst: PickupBody = ld.instance()
	inst.transform.origin = Master.Player.transform.origin 
	
	inst.velocity =  (Master.Player.dir) * 10
	Master.GameWorld.add_child(inst)
	
	#remove
	weapons.remove(current)
	current = -1
	hide_all()

func add_weapon(_weapon_name):
	pass

func has_weapon(_weapon_name):
	pass

func get_current_weapon():
	pass

func handle_pistol():
	if Input.is_action_just_pressed("fire"):
		Pistol.do_fire()

	if Input.is_action_just_pressed("hit"):
		PistolAnime.seek(0)
		PistolAnime.play("Hit", -1, 2)
		if raycast_hit.is_colliding():
			var collider = raycast_hit.get_collider()
			if collider.is_in_group("Enemy"):
				collider.do_damage(5, self)
	
	if Input.is_action_pressed("hit"):
		throw_timer -= 1 # * delta * 60
		if throw_timer < 1:
			throw_weapon()
	else:
		throw_timer = 15
