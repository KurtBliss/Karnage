extends Position3D

export(PackedScene) var pickup_ld : PackedScene

func _on_Timer_timeout():
	var inst : Spatial = pickup_ld.instance()
	get_parent().add_child(inst)
	inst.global_transform.origin = global_transform.origin
	inst.rotation = rotation
	queue_free()
