class_name Marksmen
extends Enemy

onready var bullet = preload("res://entities/actors/enemies/Bullet.tscn")
onready var muzzel = $MeshInstance/Muzzel
onready var Fire = $Fire
onready var InjuredDelay = $InjuredDelay
onready var Injured = $Injured

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
		if Fire.is_stopped():
			Fire.start()
		var gpd = get_player_distance()
		if gpd > 15:
			do_chase_player()
		else:
			do_face_player()
	else:
		Fire.stop()
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
	create_respawn()


func _on_Marksmen_injured():
	print("_on_Marksmen_injured")
	InjuredDelay.start()


func _on_InjuredDelayr_timeout():
	print("_on_InjuredDelayr_timeout")
	Injured.play()
