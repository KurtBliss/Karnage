extends Spatial
var spawn_scene_location
onready var Spawn = $Spawn

func _on_Spawn_timeout():
	if is_instance_valid(Master.Player):
		var dist = (Master.Player.transform.origin - transform.origin).length()
		print("dist to enemy spawn ", dist)
		if dist < 19:
			print("Player to close to spawn")
			Spawn.start()

	var ld = load(spawn_scene_location)
	var inst = ld.instance()
	inst.transform.origin = transform.origin
	Master.GameWorld.add_child(inst)
	queue_free()
