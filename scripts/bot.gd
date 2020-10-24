class_name Bot
extends Actor
# bot.gd

var path = []
var path_ind = 0
var path_hit_point = false
onready var nav = get_parent() if get_parent() != null else null

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
	return (Master.Player.get_translation()  - get_translation()).normalized()

func get_player_distance():
	if Master.Player == null: return null	
	return (Master.Player.get_translation()  - get_translation()).length()

func get_player_visibility():
	var space_state = get_world().get_direct_space_state()
	var hit = space_state.intersect_ray(global_transform.origin, Master.Player.global_transform.origin)
	if hit and hit.collider == Master.Player: 
			return true

func do_face_player():
	var a: Vector3 = Master.Player.get_transform().origin
	a.y = get_transform().origin.y
	look_at(a, Vector3(0,1,0))

func do_walk(spd = 2):
	var direction = -transform.basis.z.normalized() * spd
	var _vector3 = move_and_slide(direction, Vector3.UP)

func do_chase_player(spd = speed):
	do_face_player()
	do_walk(spd)

func process_path():
	if path_ind < path.size():
		var move_vec = (path[path_ind] - global_transform.origin)
		if move_vec.length() < 0.1:
			path_ind += 1
		else:
			move_and_slide(move_vec.normalized() * speed, Vector3(0, 1, 0))
	else:
		return true


