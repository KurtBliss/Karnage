class_name Weapon
extends MeshInstance
signal fired()
export var equiped : bool = true 

enum CAN_SHOOT {ANIME_END, FIRE_RATE} 
export(CAN_SHOOT) var can_shoot_mode

enum FIRE_TYPE {RAYCAST, PROJECTILE} 
export(FIRE_TYPE) var fire_type

func _ready():
	if equiped:
		if raycast:
			raycast.cast_to.z = -ray_cast_range
		else:
			print(self, " missing raycast")
	anime.play("Idle")

func do_fire():
	if can_fire:
		can_fire = false 
		timer.start(rate)
		if fire_type == FIRE_TYPE.RAYCAST:
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

func _on_Pistol_tree_entered():
	var par = get_parent()
	if par:
		if par.is_in_group("hand"):
			par.current_weapon = self


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
	if p != "":
		var _a = load(p)
