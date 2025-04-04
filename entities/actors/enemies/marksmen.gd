class_name Marksmen
extends Enemy

onready var bullet = preload("res://entities/actors/enemies/Bullet.tscn")
onready var machinegun = $MeshInstance/machinegun
onready var muzzel = $MeshInstance/machinegun/Muzzel
onready var Fire = $Fire
onready var InjuredDelay = $InjuredDelay
onready var Injured = $Injured
onready var GunRayPos = $MeshInstance/machinegun/GunRayPos
onready var BodyRayPos = $MeshInstance/BodyRayPos

func _ready():
	set_physics_state("state_idle")

func state_idle(_delta):
	if get_player_spotted():
#		delay_state_change(3, "state_chase")
		set_physics_state("state_chase")
	process_path()

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
	if not is_instance_valid(ref.player):
		return
#	machinegun.look_at(get_player_position()+Vector3(0,2.5,0),Vector3.UP)
#	machinegun.rotate_object_local(Vector3.UP,deg2rad(180))
	var inst = bullet.instance()
#	inst.set_as_toplevel(true)
	ref.level.add_child(inst)
	inst.target_group = "Player"
	inst.global_transform.origin = muzzel.global_transform.origin
	var h = ref.player.head.global_transform.origin
	h.y -= 1
	inst.look_at(h,Vector3.UP)

func get_player_visibility():
	var player = get_player()
	if player:
#		Debug Line Drawing
#		var color = Color.red
#		var color2 = Color.red
#		if raycast_fromto(GunRayPos,player,Vector3(0,0,0),Vector3(0,0.5,0)):
#			color = Color.green
#		if raycast_fromto(BodyRayPos,player,Vector3(0,0,0),Vector3(0,0.5,0)):
#			color2 = Color.green
#		ref.player.Hud.debug_lines.clear()
#		ref.player.Hud.add_debug_line(GunRayPos.global_transform.origin,player.global_transform.origin+Vector3(0,0.5,0),color)
#		ref.player.Hud.add_debug_line(BodyRayPos.global_transform.origin,player.global_transform.origin+Vector3(0,0.5,0),color2)
#		ref.player.Hud.update()
		return raycast_fromto(GunRayPos,player,Vector3(0,0,0),Vector3(0,0.5,0))&&raycast_fromto(BodyRayPos,player,Vector3(0,0,0),Vector3(0,0.5,0))


func _on_Fire_timeout():
	do_fire()


func _on_Marksmen_died():
	$Death.play("death", -1, 1.25)
	


func _on_Marksmen_injured():
	InjuredDelay.start()


func _on_InjuredDelayr_timeout():
	Injured.play()


func _on_Death_animation_finished(anim_name):
	create_respawn()
	pass # Replace with function body.
