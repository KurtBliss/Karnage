class_name Bot
extends Actor
export var detect_range = 50 #rename to detect_dist
export var detect_fov = 90
export var y_offset = 1.5
export var zig_dist = 10
onready var nav = get_parent() if get_parent() != null else null
var zig_len = 0
var path = []
var path_ind = 0
var path_hit_point = false
var bot_cast
var delay_in_progress = false
var on_floor = false

func _ready():
	speed = 7

func _process(delta):
	process_is_on_floor()

func set_path_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_ind = 0

func set_path_to_player():
	if Master.Player == null: return null	
	path =nav.get_simple_path(global_transform.origin, Master.Player.global_transform.origin)
	path_ind = 0

func get_player():
	return Master.Player

func get_player_vector():
	if Master.Player == null: return null
	var vect = (Master.Player.get_translation()  - get_translation())
	vect.angle_diff()

func get_player_distance(offset = Vector3.ZERO):
	if Master.Player == null: return null
	var _len
	if typeof(offset)==TYPE_VECTOR3:
		_len = (get_player_position() + offset - get_position()).length()
	else:
		_len = (Master.Player.get_translation() - get_translation()).length()
	return _len

func get_player_visibility():
	# doesn't work with gridmaps
	if get_player():
		return raycast(get_player())

func get_player_fov():
	if get_player():
		return detect_facing_self(get_player())

func get_player_range():
	if get_player():
		if get_player_distance() < detect_range:
			return true
	return false
	
func get_player_spotted():
	return get_player_fov() and get_player_range() and get_player_visibility()

func get_player_position():
	if get_player():
		return get_player().get_transform().origin

func get_position():
	return get_transform().origin

func calc_offset(offset: Vector3 = Vector3.ZERO):
	if raycast([get_player_position(), get_player_position() + offset], null, null, [self, get_player()]):
		return offset
	pass

func raycast(to = get_player(), name = "", offset = Vector3(0,0.5,0), exclude = [self]):
	if not to:
		return
	
	if name == null:
		name = ""
	if offset == null:
		offset = Vector3(0,0.5,0)
	
	if typeof(to) == TYPE_ARRAY:
		var space_state = get_world().get_direct_space_state()
		
		var hit = space_state.intersect_ray(to[0], to[1] , exclude)
		return hit == {}
	else:
		var space_state = get_world().get_direct_space_state()
		var hit = space_state.intersect_ray(global_transform.origin, to.global_transform.origin + offset , exclude)
		return hit && hit.collider == to

func raycast_fromto(from = self,to = get_player(), fromoffset = Vector3(0,0,0),tooffset = Vector3(0,0,0), exclude = [self]):
	if tooffset == null:
		tooffset = Vector3(0,0,0)
	if fromoffset == null:
		fromoffset = Vector3(0,0,0)
	var space_state = get_world().get_direct_space_state()
	var hit = space_state.intersect_ray(from.global_transform.origin+fromoffset, to.global_transform.origin + tooffset, exclude)
	return hit && hit.collider == to

func racycast_direct(from, to, exclude = [self]):
	var space_state = get_world().get_direct_space_state()
	var hit = space_state.intersect_ray(from, to, exclude)
	return hit

func get_player_direction():
	if get_player():
		return get_direction_to(get_player())

func get_direction_to(body: Actor):
	var vec_self = global_transform.origin
	var vec_other = body.global_transform.origin
	
	var dir = (vec_self - vec_other).normalized()
	var dir_2d = Vector2(dir.x, dir.z).angle()

	return wrap(rad2deg(dir_2d), 0, 359)

func detect_facing_self(body: Actor, fov = detect_fov ):
	var dir_to = abs(get_direction_to(body))
	var dir_dif = abs(angle_difference(dir_to, get_direction()))
	var result = dir_dif < (fov / 2)
	return result


func do_face_player(offset: Vector3 = Vector3.ZERO):
	if not get_player():
		return
	var a: Vector3 = Master.Player.get_transform().origin + offset
	a.y = get_transform().origin.y
	look_at(a, Vector3(0,1,0))
	

func do_walk(spd = speed):
	if spd == null:
		spd = speed
	var direction = -transform.basis.z.normalized() * spd
	direction.y = 0 
	velocity = direction
#	var _vector3 = move_and_slide(direction, Vector3.UP)


func do_chase_player(spd = speed, offset: Vector3 = Vector3.ZERO):
	if spd == null:
		spd = speed
	if get_player():
		if get_player_distance() > 3:
			do_face_player(offset)
			do_walk(spd)



func delay_state_change(delay:float, state = get_state(), phys_state = get_physics_state(), blank_state = true, callback = null):
	if delay_in_progress:
		return
	delay_in_progress = true
	if blank_state:
		set_state("")
		set_physics_state("")
	yield(get_tree().create_timer(delay), "timeout")
	set_state(state)
	set_physics_state(phys_state)
	if callback and has_meta(callback):
		call(callback)
	delay_in_progress = false

func process_path():
	if path_ind < path.size():
		var move_vec = (path[path_ind] - global_transform.origin + Vector3(0, y_offset, 0))
		if move_vec.length() < 0.1:
			path_ind += 1
		else:
			var dir = move_vec.normalized() * speed
			dir.y = 0
			velocity = dir
#			var _tmp = move_and_slide(move_vec.normalized() * speed, Vector3(0, 1, 0))
		return true
	return false
	
func process_is_on_floor():
	var pfrom = get_position()
	var pto = pfrom
	pto.y -= 1.1
	var cast = racycast_direct(pfrom, pto)
	on_floor = cast and cast.collider

func check_projection(start:Vector3, projected:Vector3, point:Vector3):
	if raycast([start, projected]):
		if raycast([projected, point]):
			return true
	return false


