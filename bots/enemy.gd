extends Bot

var target
var target_pos = Vector3.ZERO

func _ready():
	set_physics_state("state_idle")

func state_idle(delta):
	if not get_player():
		return
	var is_not_hidden = $Player.player_is_visible
	var is_in_range = get_player_distance() < 100
	
	if is_not_hidden and is_in_range:
		if Input.is_action_just_pressed("debugEnemy"):
			print("spotted")
#		print("switching state to chase")
#		set_physics_state("state_chase")

func state_chase(delta):
	if not get_player():
		return
	var is_not_close = get_player_distance() > 5
	var is_not_hidden = $Player.player_is_visible
	if is_not_close and is_not_hidden:
		do_chase_player()
#	else:
		

#func state_chase_path(delta):
#	if not get_player():
#		return
#	var is_running = process_path()
#	var is_not_hidden = $Player.player_is_visible
#	if is_running:
#		if is_not_hidden:
#			if Master.Player.is_on_floor():
#				set_physics_state("state_chase")

func _on_FOV_body_entered(body):
	if body.is_in_group("Player"):
		target = body
		print("Player _on_FOV_body_entered")

