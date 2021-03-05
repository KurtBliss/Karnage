"""Pistol.gd"""
extends MeshInstance
signal fired()
enum CAN_SHOOT {ANIME_END, FIRE_RATE} 
export(CAN_SHOOT) var can_shoot_mode
export var equiped : bool = true

# Stats
export var damage : int = 0
export var ray_cast_range : int = 0 
export var rate : float = 0 
export var fire_anime_speed : float = 1

# Node References
export(String, "None", "Enemy", "Player") var target_group
export(NodePath) onready var raycast_path
export(NodePath) onready var holder_path
export(String, FILE, "*.tscn") onready var pickup_file
onready var raycast : RayCast = get_node(raycast_path)
onready var holder : Actor = get_node(holder_path)
onready var anime : AnimationPlayer = $Anime
onready var timer : Timer = $Rate 

var can_fire = true

func _ready():
	if equiped:
		raycast.cast_to.z = -ray_cast_range

func do_fire():
	if can_fire:
		can_fire = false 
		timer.start(rate)
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider.is_in_group(target_group):
				collider.do_damage(damage, holder)
		anime.play("Fire", -1, fire_anime_speed)
		emit_signal("fired")

func _on_Rate_timeout():
	if can_shoot_mode == CAN_SHOOT.FIRE_RATE:
		can_fire = true

func _on_Anime_animation_finished(anim_name):
	if anim_name == "Fire":
		if can_shoot_mode == CAN_SHOOT.ANIME_END:
			can_fire = true
