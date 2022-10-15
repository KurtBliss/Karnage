"""pickup.gd"""
extends Area
var curbody = null # Players body... 
onready var parrent = get_parent()

func _ready():
	pass

func _process(_delta):
	if not curbody:
		return
	
	if Input.is_action_just_pressed("interact") and curbody is Player:
		var weapons = curbody.weapon
		if true:#not weapons.has_weapon():
			if weapons.add_weapon(parrent.weapon):
				parrent.queue_free()
	
	elif curbody is Goomba:
		print("CURBODY IS GOOMBA")
		var weapons = curbody.weapon
		if weapons.add_weapon(parrent.weapon):
			parrent.queue_free()

func _on_PistolPickup_body_entered(body):
	if body == ref.player or body is Goomba:
		curbody = body

func _on_Area_body_exited(body):
	if body == curbody:
		curbody = null
