class_name Projectile
extends Position3D
var last_position = global_transform.origin
export(String, "None", "Enemy", "Player") var target_group
export(float) var speed = 5
export(int) var damage = 7
var ignore = [self]
var holder : Actor
var face = Vector3.ZERO

func _ready():
#	face = -ref.player.camera.global_transform.basis.z.normalized()
#	look_at(ref.player.camera.get_node("Tar").global_transform.origin, Vector3.UP)
	
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
		if hit.collider.is_in_group(target_group):
			hit.collider.do_damage(damage, holder)
	
		queue_free()


func raycast_direct(from, to, exclude = [self]):
	var space_state = get_world().get_direct_space_state()
	var hit = space_state.intersect_ray(from, to, exclude)
	return hit
