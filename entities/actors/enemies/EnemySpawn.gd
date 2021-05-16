extends Spatial
var spawn_scene_location
onready var Spawn = $Spawn

func _on_Spawn_timeout():
	if is_instance_valid(ref.player):
		var dist = (ref.player.transform.origin - transform.origin).length()
		if $Bot.get_player_visibility() or dist < 60:
			Spawn.start()
			return
	var ld
	if ref.level.loads.has(spawn_scene_location):
		ld = ref.level.loads[spawn_scene_location]
	else:
		ld = load(spawn_scene_location)
		ref.level.loads[spawn_scene_location] = ld
	var inst = ld.instance()
	inst.transform.origin = transform.origin
	ref.level.add_child(inst)
	queue_free()
