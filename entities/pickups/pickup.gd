extends Area

export(String) var weapon_pickup_name = "Pistol"

var curbody = null

func _ready():
	set_process(false)

func _process(_delta):
	if not Input.is_action_just_pressed("interact"):
		return
	var weapons = curbody.Weapons
	if !weapons.has_weapon(weapon_pickup_name):
		weapons.add_weapon(weapon_pickup_name)
		weapons.switch_weapon_by_name(weapon_pickup_name)
		queue_free()

func _on_PistolPickup_body_entered(body):
	print("player touched pistol pickup")
	if body == Master.Player:
		curbody = body
		set_process(true)
	elif body.is_in_group("enemy"):
		if get_parent().velocity.length() > 0:
			body.do_damage(3, null)

func _on_Area_body_exited(body):
	if body == curbody:
		set_process(false)
