extends Area

export(String) var weapon_pickup_name = "Pistol"

func _on_PistolPickup_body_entered(body):
	if body == Master.Player:
		var weapons = Master.Player.Weapons
		if !weapons.has_weapon(weapon_pickup_name):
			weapons.add_weapon(weapon_pickup_name)
			weapons.switch_weapon_by_name(weapon_pickup_name)
			queue_free()
