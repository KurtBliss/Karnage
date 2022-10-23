class_name SentryGun
extends Enemy

onready var bullet = preload("res://entities/actors/enemies/Bullet.tscn")

func _ready():
	gravity = 0
	knockable = false
	set_physics_state("physics_idle")

func _physics_process(_delta):
	$Label3D.text = get_physics_state()
	._physics_process(_delta)

func physics_idle(_delta):
	if is_instance_valid(ref.player):
		var prev_rot = rotation
		look_at(ref.player.global_transform.origin, Vector3.UP)
		var rot = rotation
		rotation = prev_rot.linear_interpolate(rot, 0.05)

func state_idle(_delta):
	physics_idle(_delta)

func _on_attacked(_dmg):
	$HitAnimationPlayer.seek(0)
	$HitAnimationPlayer.play("Hit")
	print_debug("ON_ATTACKED")
	pass

func _on_SentryGun_died():
	create_respawn(60)
	queue_free()

func do_fire():
	if not is_instance_valid(ref.player):
		return
#	machinegun.look_at(get_player_position()+Vector3(0,2.5,0),Vector3.UP)
#	machinegun.rotate_object_local(Vector3.UP,deg2rad(180))
	$FireAnimationPlayer.play("fire")
	var inst = bullet.instance()
#	inst.set_as_toplevel(true)
	ref.level.add_child(inst)
	inst.target_group = "Player"
	inst.global_transform.origin = $Muzzle.global_transform.origin
	inst.rotation = rotation
#	var h = ref.player.head.global_transform.origin
#	h.y -= 1
#	inst.look_at(h,Vector3.UP)


func _on_Fire_timeout():
	print_debug("FIRE")
	do_fire()
	pass # Replace with function body.
	

func _on_SentryGun_injured():
	print_debug("INJURED")
	

	
	

