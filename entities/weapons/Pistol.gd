"""Pistol.gd"""
extends MeshInstance
signal fired()
export var can_pickup : bool = false
export var damage : int = 0
export var ray_cast_range : int = 0 setget set_range
export var rate : float = 0.5 setget set_rate
export(String, "None", "Enemy", "Player") var target_group
export(NodePath) onready var raycast_path
export(NodePath) onready var holder_path
onready var raycast : RayCast = get_node(raycast_path)
onready var holder : Actor = get_node(holder_path)
onready var anime : AnimationPlayer = $AnimationPlayer
onready var timer : Timer = $Rate 
var can_fire = true

func do_fire():
	if can_fire:
		can_fire = false
		
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.is_in_group(target_group):
			collider.do_damage(damage, holder)
	anime.play("Fire")

func set_rate(wait : float):
	timer.wait_time = wait
	rate = wait

func set_range(r : int):
	raycast.cast_to.z = -r
	ray_cast_range = r
