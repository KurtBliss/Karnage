class_name Projectile
extends Position3D
var last_position = global_transform.origin
export(String, "None", "Enemy", "Player") var target_group
export(float) onready var speed = 5
export(int) onready var damage = 7
var ignore = [self]
var holder : Actor
var face = Vector3.ZERO
var other_shots = []
var type = ""

func _ready():
	if target_group == "Enemy":
		ignore.append(Player)
	elif target_group == "Player":
		ignore.append(Enemy)

func _physics_process(_delta : float) -> void:
	last_position = global_transform.origin
	
	face = -global_transform.basis.z.normalized()
	global_transform.origin += face * speed
	
	var hit = raycast_direct(last_position, global_transform.origin + (face * 10))
	if hit.has("collider"):	
		
		if holder.is_in_group("enemy"):
			target_group = "Player"
		
		if hit.collider.is_in_group(target_group):
			hit.collider.do_damage(damage, holder, type)
	
		if holder.is_in_group("player") \
		and hit.collider.is_in_group("challenge_targets"):
			hit.collider._on_shot()
	
		queue_free()


func raycast_direct(from, to, exclude = [self]):
	var space_state = get_world().get_direct_space_state()
	var hit = space_state.intersect_ray(from, to, exclude)
	return hit
