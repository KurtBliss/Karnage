extends Area

func _on_PistolPickup_body_entered(body):
	if body == Master.Player:
		var weapons = Master.Player.Weapons
		print(weapons) #not getting node..... 
		if !weapons.has_weapon("Pistol"):
			weapons.add_weapon("Pistol")
			weapons.switch_weapon_by_name("Pistol")
			queue_free()
