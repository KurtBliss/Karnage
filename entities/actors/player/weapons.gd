""".../player/weapons.gd"""
extends Spatial

export(NodePath) onready var holder_path
onready var holder = get_node(holder_path)

var current = -1
var weapons = []
var current_weapon : Weapon
var throw_timer = 60*2
onready var raycast = $"../RayLong"
onready var raycast_hit = $"../RayShort"

func _ready():
	add_to_group("hand")
	current_weapon = get_child(0)
	if is_instance_valid(current_weapon):
		weapons.append(current_weapon)
		current = 0 #weapons size
		holder.do_emit_clip(current_weapon.clip)
		call_deferred("ready_deferred")
		

func ready_deferred():
	holder.do_emit_ammo(holder.ammo[current_weapon.ammo_type])		
	

func _process(_delta):
#	if weapons.size() < 1:
#		return
	var can_input = Master.input_enabled()
	
	if is_instance_valid(current_weapon):
		if current_weapon.automatic:
			if Input.is_action_pressed("fire") and can_input:
				current_weapon.do_fire()
		else:
			if Input.is_action_just_pressed("fire") and can_input:
				current_weapon.do_fire()
		
		if Input.is_action_just_pressed("reload") and can_input:
			current_weapon.start_reload()

			
		if Input.is_action_pressed("hit") and can_input:
			throw_timer -= 1 # * delta * 60
			if throw_timer < 1:
				throw_weapon()
		else:
			throw_timer = 15
			
		if Input.is_action_just_pressed("hit") and can_input:
			var hit = false
			current_weapon.anime.seek(0)
			current_weapon.anime.play("Hit", -1, 2)
			if raycast_hit.is_colliding():
				var collider = raycast_hit.get_collider()
				if collider.is_in_group("Enemy"):
					collider.do_damage(5, holder)
					hit = true
			holder.do_emit_hit(hit, current_weapon.name, -1, true)
		
	if Input.is_action_just_pressed("switch_weapon"):
		switch_weapon()

	

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
	print(cur)
	var ld = load(cur.pickup_file)
	var inst: PickupBody = ld.instance()
	inst.pass_clip = cur.clip
	inst.rotation_degrees.y = get_parent().get_parent().rotation_degrees.y + 180
	inst.transform.origin = ref.player.transform.origin
	holder.do_emit_clip(-1)
	inst.velocity =  (ref.player.dir) * 10
	cur.queue_free()
	ref.level.add_child(inst)
	current_weapon = null

	#remove
	weapons.remove(current)
	current = -1

func add_weapon(weapon : Weapon):
	
	if not is_instance_valid(weapon):
		return false
	
	if is_instance_valid(current_weapon):
		if current_weapon.name == weapon.name:
			return false
		
		current_weapon.equiped = false
		current_weapon.visible = false

	current_weapon = weapon	
	weapons.append(weapon)
	current = weapons.size() - 1
	weapon.equiped = true
	weapon.target_group = "Enemy"
	weapon.raycast_path = String(raycast.get_path())+String(raycast.name)
	weapon.holder_path = String(holder.get_path())+String(holder.name)
	weapon.raycast = raycast
	weapon.holder = holder
	holder.do_emit_clip(weapon.clip)
	Master.reparent(weapon, self)
	return true

func has_weapon(_weapon_name):
	return has_node(_weapon_name)

func get_current_weapon():
	return current_weapon
