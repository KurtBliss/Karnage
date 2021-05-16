"""Corridor"""
extends Level

var targets_reached = false
var princess_saved = false

func _on_target_reached():
	if not targets_reached:
		if is_instance_valid(ref.player):
			if ref.player.health > 0:
				if not ref.player.Weapon.has_weapon("Shotgun"):
					var shotgun_ld = preload("res://entities/weapons/Shotgun.tscn")
					var shotgun = shotgun_ld.instance()
					add_child(shotgun)
					ref.player.Weapon.add_weapon(shotgun)
					targets_reached = true
				elif not ref.player.Weapon.has_weapon("M16"):
					var shotgun_ld = preload("res://entities/weapons/M16.tscn")
					var shotgun = shotgun_ld.instance()
					add_child(shotgun)
					ref.player.Weapon.add_weapon(shotgun)
					targets_reached = true

func _on_Health_grabbed():
	ref.level.secret_area = true
	pass # Replace with function body.

func _on_switch_switched(on):
	$CagesAnime.play("down")


func _on_Princess_saved():
	princess_saved = true
	pass # Replace with function body.
