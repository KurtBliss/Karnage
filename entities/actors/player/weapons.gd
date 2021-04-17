"""../player/weapons.gd"""
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

func _process(_delta):
#	if weapons.size() < 1:
#		return
	var can_input = Master.input_enabled()
	
	if current_weapon:
		if current_weapon.automatic:
			if Input.is_action_pressed("fire") and can_input:
				current_weapon.do_fire()
		else:
			if Input.is_action_just_pressed("fire") and can_input:
				current_weapon.do_fire()
				holder.do_emit_fire()
			
		if Input.is_action_pressed("hit") and can_input:
			throw_timer -= 1 # * delta * 60
			if throw_timer < 1:
				throw_weapon()
		else:
			throw_timer = 15
			
		if Input.is_action_just_pressed("hit") and can_input:
			current_weapon.anime.seek(0)
			current_weapon.anime.play("Hit", -1, 2)
			if raycast_hit.is_colliding():
				var collider = raycast_hit.get_collider()
				if collider.is_in_group("Enemy"):
					collider.do_damage(5, self)

	

func throw_weapon():
	#spawn
	var cur = get_current_weapon()
	if cur == null:
		return
	print(cur)
	var ld = load(cur.pickup_file)
	var inst: PickupBody = ld.instance()
	inst.transform.origin = Master.Player.transform.origin 
	
	inst.velocity =  (Master.Player.dir) * 10
	cur.queue_free()
	Master.GameWorld.add_child(inst)
	current_weapon = null
	
	
	#remove
	weapons.remove(current)
	current = -1

func add_weapon(weapon : Node):
	if current_weapon:
		current_weapon.queue_free()
	
	current_weapon = weapon
	print("adding weapon, ", weapon)
	
	if not weapon == null:	
		weapons.append(weapon)
		weapon.equiped = true
		weapon.target_group = "Enemy"
		weapon.raycast_path = String(raycast.get_path())+String(raycast.name)
		weapon.holder_path = String(holder.get_path())+String(holder.name)
		weapon.raycast = raycast
		weapon.holder = holder
		Master.reparent(weapon, self)

func has_weapon(_weapon_name):
	return has_node(_weapon_name)

func get_current_weapon():
	return current_weapon
#
#func handle_pistol():
#	if Input.is_action_just_pressed("hit"):
#		PistolAnime.seek(0)
#		PistolAnime.play("Hit", -1, 2)
#		if raycast_hit.is_colliding():
#			var collider = raycast_hit.get_collider()
#			if collider.is_in_group("Enemy"):
#				collider.do_damage(5, self)
#
