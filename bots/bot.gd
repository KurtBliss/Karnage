class_name Bot
extends Actor
# bot.gd

var path = []
var path_ind = 0
var path_hit_point = false
onready var nav = get_parent() if get_parent() != null else null

var direction_offset = 180

func set_path_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_ind = 0

func set_path_to_player():
	if Master.Player == null: return null	
	path = nav.get_simple_path(global_transform.origin, Master.Player.global_transform.origin)
	path_ind = 0

func get_player():
	return Master.Player

func get_player_direction():
	if Master.Player == null: return null
	var vect = (Master.Player.get_translation()  - get_translation())
	vect.angle_diff()

func get_player_distance():
	if Master.Player == null: return null	
	return (Master.Player.get_translation()  - get_translation()).length()

func get_player_visibility(gridmap = false):
	# doesn't work with gridmaps
	var space_state = get_world().get_direct_space_state()
	
	var hit = space_state.intersect_ray(global_transform.origin, Master.Player.global_transform.origin, [self])
		
	if hit and hit.collider == Master.Player: 
		return true
	else:
		return false
	
func get_direction():
	return wrap(rotation_degrees.y + direction_offset, 0, 359)

func get_direction_to(body: Actor):
	var vec_self = global_transform.origin
	var vec_other = body.global_transform.origin
	
	var dir = (vec_self - vec_other).normalized()
	var dir_2d = Vector2(dir.x, dir.z).angle()

	return wrap(rad2deg(dir_2d), 0, 359)

func detect_facing_self(body: Actor, fov):
	
	#fov seems to widee...
	
	var dir_to = get_direction_to(body)
	var dir_dif = angle_difference(dir_to, get_direction())
	var result = dir_dif < (fov / 2)
	
	
	print(result, dir_to, dir_dif)
	
	
	if result:
		return true
	else:
		return false


func do_face_player():
	var a: Vector3 = Master.Player.get_transform().origin
	a.y = get_transform().origin.y
	look_at(a, Vector3(0,1,0))

func do_walk(spd = 2):
	var direction = -transform.basis.z.normalized() * spd
	var _vector3 = move_and_slide(direction, Vector3.UP)

func do_chase_player(spd = speed):
	if get_player_distance() > 5:
		do_face_player()
		do_walk(spd)

func process_path():
	if path_ind < path.size():
		var move_vec = (path[path_ind] - global_transform.origin)
		if move_vec.length() < 0.1:
			path_ind += 1
		else:
			move_and_slide(move_vec.normalized() * speed, Vector3(0, 1, 0))
		print("processed path")
		return true
	else:
		print("completed path")
		return false

func angle_difference(ang0, ang1):
	return ((((ang0 - ang1) % 360) + 540) % 360) - 180;

func wrap(value, _min, _max):
	_min = int(floor(_min))
	_max = int(floor(_max))
	value = int(floor(value))
	var _mod = ( value - _min ) % ( _max - _min )
	if ( _mod < 0 ): 
		return _mod + _max 
	else: 
		return _mod + _min
