"""pickup.gd"""
extends Area
var curbodies = []
onready var parrent = get_parent()

func _ready():
	pass

func _process(_delta):
	for body in curbodies:
		process_body(body)

func process_body(curbody):
	if not curbody:
		return
	
	if  curbody is Player \
	and !curbody.weapon.has_weapon(parrent.weapon.name):
		ref.hud.hide_pick_delay = 1
	
	if Input.is_action_just_pressed("interact") and curbody is Player:
		var weapons : WeaponContainer = curbody.weapon
		if true:#not weapons.has_weapon():
			if weapons.add_weapon(parrent.weapon):
				
				parrent.queue_free()
	
	elif curbody is Goomba:
		if curbody.do_pickup > 0:
			var weapons = curbody.weapon
			if weapons.add_weapon(parrent.weapon, "Player"):
				parrent.queue_free()

func _on_PistolPickup_body_entered(body):
	if body == ref.player or body is Goomba:
		if !curbodies.has(body):
			curbodies.push_back(body)

func _on_Area_body_exited(body):
	if curbodies.has(body):
		curbodies.erase(body)
