extends Bot

enum {IDLE, USE_PATHFING, PLAYER_IN_RANGE}
var state_ = USE_PATHFING

func _ready():
	set_physics_state("state_in_range")

func state_idle(delta):
	if not get_player():
		return
	
	var is_not_hidden = get_player_visibility()
	var is_visible = get_player_direction()<45
		
	if is_not_hidden and is_visible:
		set_physics_state("state_chase")
	

func state_chase(delta):
	if not get_player():
		return
	
	var is_not_close = get_player_distance() > 5
	var is_not_hidden = get_player_visibility()
	
	if is_not_close and is_not_hidden:
		do_chase_player()
	elif is_not_close:
		set_path_to_player()
		set_physics_state("state_chase_path")

func state_chase_path(delta):
	if not get_player():
		return
	
	var is_running = process_path()
	var is_not_hidden = get_player_visibility()
	
	if is_running:
		if is_not_hidden:
			set_physics_state("is_not_hidden")
		pass
	

