class_name Marksmen
extends Enemy

onready var bullet = preload("res://entities/actors/enemies/Bullet.tscn")
onready var machinegun = $Mannequin/Skeleton/BoneAttachment/MeshInstance/machinegun#$MeshInstance/machinegun
onready var muzzel = $Mannequin/Skeleton/BoneAttachment/MeshInstance/machinegun/Muzzel #$MeshInstance/machinegun/Muzzel
onready var Fire = $Fire
onready var InjuredDelay = $InjuredDelay
onready var Injured = $Injured
onready var GunRayPos = $Mannequin/Skeleton/BoneAttachment/MeshInstance/machinegun/GunRayPos #$MeshInstance/machinegun/GunRayPos
onready var BodyRayPos = $Mannequin/Skeleton/BoneAttachment/MeshInstance/BodyRayPos #$MeshInstance/BodyRayPos
onready var anime = $Mannequin/Anime

func _ready():
	set_physics_state("state_idle")

func state_idle(_delta):
	anime.play("Idle")
	if get_player_spotted():
#		delay_state_change(3, "state_chase")
		set_physics_state("state_chase")
	process_path()

func state_chase(_delta):
	if not anime.is_playing():
		anime.play("Walk")
	if not get_player():
		return
	if get_player_visibility():
		if Fire.is_stopped():
			anime.play("Aim")
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
	anime.play("Walk")
	if get_player_visibility():
		set_physics_state("state_chase")
		return
	var process = process_path()
	if not process:
		set_path_to_player()

func do_fire():
	if !get_player():
		return
	machinegun.look_at(get_player_position()+Vector3(0,2.5,0),Vector3.UP)
#	machinegun.rotate_object_local(Vector3.UP,deg2rad(180))
	var inst = bullet.instance()
	muzzel.add_child(inst)

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
#		Master.Player.Hud.debug_lines.clear()
#		Master.Player.Hud.add_debug_line(GunRayPos.global_transform.origin,player.global_transform.origin+Vector3(0,0.5,0),color)
#		Master.Player.Hud.add_debug_line(BodyRayPos.global_transform.origin,player.global_transform.origin+Vector3(0,0.5,0),color2)
#		Master.Player.Hud.update()
		return raycast_fromto(GunRayPos,player,Vector3(0,0,0),Vector3(0,0.5,0))&&raycast_fromto(BodyRayPos,player,Vector3(0,0,0),Vector3(0,0.5,0))


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
