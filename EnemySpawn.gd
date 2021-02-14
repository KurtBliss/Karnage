extends Spatial

var spawn_scene_location	


func _on_Spawn_timeout():
	var ld = load(spawn_scene_location)
	var inst = ld.instance()
	inst.transform.origin = transform.origin
	Master.GameWorld.add_child(inst)
	queue_free()
