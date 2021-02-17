class_name Marksmen
extends Enemy

onready var bullet = preload("res://entities/bots/Bullet.tscn")
onready var muzzel = $MeshInstance/Muzzel

func _ready():
	set_physics_state("state_idle")

func state_idle(_delta):
	if get_player_spotted():
#		delay_state_change(3, "state_chase")
		set_physics_state("state_chase")

func state_chase(_delta):
	if not get_player():
		return
	if get_player_visibility():
		var gpd = get_player_distance()
		if gpd > 15:
			do_chase_player()
		else:
			do_face_player()
			if $Fire.is_stopped():
				$Fire.start()
	else:
		set_path_to_player()
		set_physics_state("state_chase_path")

func state_chase_path(_delta):
	if get_player_visibility():
		set_physics_state("state_chase")
		return
	var process = process_path()
	if not process:
		set_path_to_player()

func do_fire():
	var inst = bullet.instance()
	muzzel.add_child(inst)

func _on_Fire_timeout():
	do_fire()


func _on_Marksmen_died():
	get_player().score += 10
	var ld = load("res://entities/bots/EnemySpawn.tscn")
	var inst = ld.instance()
	inst.transform.origin = starting_origin
	inst.spawn_scene_location = filename
	Master.GameWorld.add_child(inst)
	queue_free()
