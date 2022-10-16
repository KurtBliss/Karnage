class_name WeaponContainer
extends Spatial

export(NodePath) onready var holder_path
onready var holder = get_node(holder_path)

export(NodePath) onready var raycast_path
onready var raycast = get_node(raycast_path)


var current = -1
var weapons = []
var current_weapon : Weapon
var throw_timer = 60*2
#onready var raycast = $"../RayLong"
onready var raycast_hit = $"../RayShort"

func _ready():
	add_to_group("hand")
	current_weapon = get_child(0)
	if is_instance_valid(current_weapon):
		weapons.append(current_weapon)
		current = 0 #weapons size
		if holder.has_method("do_emit_clip"):
			holder.do_emit_clip(current_weapon.clip)
		call_deferred("ready_deferred")

func ready_deferred():
	if holder.has_method("do_emit_ammo"):
		holder.do_emit_ammo(holder.ammo[current_weapon.ammo_type])		
	
#func has_weapon(weapon_name):
#	var weapons = get_children()
#	for wpn in weapons:
#		if wpn.name == weapon_name:
#			return true
#	return false

func switch_weapon():
	var count = weapons.size()
	var switch_to = current + 1
	
	if count == 0:
		return
	
	if switch_to > count - 1:
		switch_to = 0
	
	if is_instance_valid(current_weapon):
		current_weapon.visible = false
		current_weapon.equiped = false
	
	current = switch_to
	current_weapon = weapons[current]
	current_weapon.visible = true
	current_weapon.equiped = true
	
	holder.do_emit_clip(current_weapon.clip)
	holder.do_emit_ammo(holder.ammo[current_weapon.ammo_type])
	

func throw_weapon():
	#spawn
	var cur = get_current_weapon()
	if cur == null:
		return
	
	var ld = load(cur.pickup_file)
	var inst: PickupBody = ld.instance()
	inst.pass_clip = cur.clip
	inst.rotation_degrees.y = get_parent().get_parent().rotation_degrees.y + 180
	inst.transform.origin = ref.player.transform.origin
	if holder is Player:
		holder.do_emit_clip(-1)
		inst.velocity =  (ref.player.dir) * 10
	cur.queue_free()
	ref.level.add_child(inst)
	current_weapon = null

	#remove
	weapons.remove(current)
	current = -1

func add_weapon(weapon : Weapon, target_group = "Enemy"):
	if has_weapon(weapon.name):
		return false
	
	if not is_instance_valid(weapon):
		return false
	
	if is_instance_valid(current_weapon):
		if current_weapon.name == weapon.name:
			return false
		
		current_weapon.equiped = false
		current_weapon.visible = false

	current_weapon = weapon	
	weapon.rotation.y = 0
	weapons.append(weapon)
	current = weapons.size() - 1
	weapon.equiped = true
	weapon.target_group = target_group
	weapon.raycast_path = String(raycast.get_path())+String(raycast.name)
	weapon.holder_path = String(holder.get_path())+String(holder.name)
	weapon.raycast = raycast
	weapon.holder = holder
	if holder is Player:
		weapon.set("layers", 2)
	if holder.has_method("do_emit_clip"):
		holder.do_emit_clip(weapon.clip)
	Master.reparent(weapon, self)
	return true

func has_weapon(_weapon_name):
	return has_node(_weapon_name)

func get_current_weapon():
	return current_weapon
