class_name AmmoPickup
extends MeshInstance
export(Master.AMMO) var type 
export(int) var size

func _on_Area_body_entered(body: Player):
	if not body:
		return
	if body.is_in_group("player"):
		body.ammo[type] += size
		
		if body.weapon.current_weapon:
			var t = body.weapon.current_weapon.ammo_type
			body.do_emit_ammo(body.ammo[t])
			queue_free()
