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

			var respawn_ld = preload("res://entities/pickups/RespawnPickup.tscn")
			var inst = respawn_ld.instance()
			get_parent().add_child(inst)
			inst.global_transform.origin = global_transform.origin
			inst.rotation = rotation
			inst.pickup_ld = load(filename)
			
			queue_free()
