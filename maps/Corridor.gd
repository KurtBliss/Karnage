"""Corridor"""
extends Level

func _on_target_reached():
	if is_instance_valid(ref.player):
		if ref.player.health > 0:
			var shotgun_ld = preload("res://entities/weapons/Shotgun.tscn")
			var shotgun = shotgun_ld.instance()
			add_child(shotgun)
			ref.player.Weapon.add_weapon(shotgun)
