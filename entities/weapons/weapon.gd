class_name Weapon
extends MeshInstance
#signal fired()
export var equiped : bool = true 

enum CAN_SHOOT {ANIME_END, FIRE_RATE} 
export(CAN_SHOOT) var can_shoot_mode

enum FIRE_TYPE {RAYCAST, PROJECTILE} 
export(FIRE_TYPE) var fire_type

export(bool) var automatic = false

export(Master.AMMO) var ammo_type

export(int) var clip_size = 6
export(int) var clip  = clip_size

var b_decal = preload("res://entities/decals/BulletDecal.tscn")

func _ready():
	if equiped:
		if raycast:
			raycast.cast_to.z = -ray_cast_range
		else:
			print(self, " missing raycast")
	anime.play("Idle")

func do_fire():
	if can_fire:
		if clip > 0:
			clip -= 1
			can_fire = false 
			timer.start(rate)
			if fire_type == FIRE_TYPE.RAYCAST:
				if raycast.is_colliding():
					var collider = raycast.get_collider()
					if collider.is_in_group(target_group):
						collider.do_damage(damage, holder)
					else:
						var aa = collider is GridMap 
						var bb = collider.is_in_group("door")
						if aa or bb:
							var b = b_decal.instance()
							collider.add_child(b)
							b.global_transform.origin = raycast.get_collision_point()
							b.look_at(raycast.get_collision_point() + raycast.get_collision_normal(), Vector3.UP)
			anime.play("Fire", -1, fire_anime_speed)
			holder.do_emit_fire()
			holder.do_emit_clip(clip)
			holder.do_emit_ammo(holder.ammo[ammo_type])
		

func start_reload():
	if can_fire:
		can_fire = false
		anime.play("Reload", -1, reload_anime_speed)

func do_reload():
	while clip < clip_size:
		if holder.ammo[ammo_type] == null:
			return
		if holder.ammo[ammo_type] > 0:
			holder.ammo[ammo_type] -= 1
			clip += 1
			holder.do_emit_clip(clip)
			holder.do_emit_ammo(holder.ammo[ammo_type])
		else:
			return

func _on_Rate_timeout():
	if can_shoot_mode == CAN_SHOOT.FIRE_RATE:
		can_fire = true

func _on_Anime_animation_finished(anim_name):
	if anim_name == "Fire":
		if can_shoot_mode == CAN_SHOOT.ANIME_END:
			can_fire = true
	elif anim_name == "Hit":
		if can_shoot_mode == CAN_SHOOT.ANIME_END:
			can_fire = true
			anime.play("Idle")
	elif anim_name == "Reload":
		can_fire = true
		do_reload()

func _on_Pistol_tree_entered():
	var par = get_parent()
	if par:
		if par.is_in_group("hand"):
			par.current_weapon = self
			holder.do_emit_clip(clip)
			holder.do_emit_ammo(holder.ammo[ammo_type])			


# Stats
export var damage : int = 0
export var ray_cast_range : int = 0 
export var rate : float = 0 
export var fire_anime_speed : float = 1
export var reload_anime_speed : float = 0.7

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
