extends Bot
class_name Zombie
var attack

func _ready():
	add_to_group("Zombie")
	add_to_group("Enemy")
	state_reset("state_normal", "")
	connect("injured", Master.Player, "enemy_injured")
	connect("death", Master.Player, "enemy_death")
	

func _death():
	queue_free()
 
func state_normal(delta):
	if get_player_distance() < 400:
		if get_player_visibility():
			state_reset("", "state_chase")
		else:
			set_path_to_player()
			state_reset("", "state_chase_path")

func state_chase_path(delta):
	if get_player_visibility():
		state_reset("", "state_chase")
	if process_path():
		state_reset("", "state_normal")

func state_chase(delta):
	if get_player_visibility():
		do_chase_player()
	else:
		state_reset("", "state_normal")


func _on_Zombie_injured():
	$MeshInjured.visible = true
	$Timer.start()
	pass # Replace with function body.


func _on_Timer_timeout():
	$MeshInjured.visible = false
	pass # Replace with function body.
