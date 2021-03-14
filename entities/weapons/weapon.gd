class_name Weapon
extends MeshInstance
signal fired()
export var equiped : bool = true 

enum CAN_SHOOT {ANIME_END, FIRE_RATE} 
export(CAN_SHOOT) var can_shoot_mode

enum FIRE_TYPE {RAYCAST, PROJECTILE} 
export(FIRE_TYPE) var fire_type


# Stats
export var damage : int = 0
export var ray_cast_range : int = 0 
export var rate : float = 0 
export var fire_anime_speed : float = 1

# Node References
export(String, "None", "Enemy", "Player") var target_group
export(NodePath) onready var raycast_path
export(NodePath) onready var holder_path
export(NodePath) onready var animation_player
export(NodePath) onready var cock_path
export(String, FILE, "*.tscn") onready var pickup_file
export(String, FILE, "*.tscn") onready var projectile_file setget set_projectile
onready var projectileInst
onready var raycast #: RayCast 
onready var holder #: Actor 
onready var anime : AnimationPlayer = get_node(animation_player)
onready var timer : Timer = $Rate 
onready var cock = get_node(cock_path) 

var can_fire = true

func set_equiped(e):
	equiped = e
	if e:
		cock.play()

func set_projectile(p):
	
	var a = load(p)
