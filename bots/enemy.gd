extends Bot

enum {IDLE, USE_PATHFING, PLAYER_IN_RANGE}
var state_ = USE_PATHFING

func _ready():
	set_physics_state("state_idle")

func state_idle(delta):
	if not get_player():
		return
	
	var is_not_hidden = get_player_visibility()
	
#	print(rad2deg(get_player_direction()))
	var dir = get_player_direction()
	
	print(Vector3(rad2deg(dir.x), rad2deg(dir.y), rad2deg(dir.z)))
	
#	var is_visible = get_player_direction() < 45
#
#	if is_not_hidden and is_visible:
#		set_physics_state("state_chase")
#

func state_chase(delta):
	if not get_player():
		return
	
	var is_not_close = get_player_distance() > 5
	var is_not_hidden = get_player_visibility()
	
	if is_not_close and is_not_hidden:
		print("28")
		do_chase_player()
	elif is_not_close:
		print("31")		
		set_path_to_player()
		set_physics_state("state_chase_path")

func state_chase_path(delta):
	if not get_player():
		return
	
	var is_running = process_path()
	var is_not_hidden = get_player_visibility()
	
	if is_running:
		if is_not_hidden:
			set_physics_state("state_chase")
		else:
			pass #player allready moved... ^
	

