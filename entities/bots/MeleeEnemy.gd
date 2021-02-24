extends Enemy

func _ready(): 
	set_drain_on_proximity(false)
	set_physics_state("state_idle")

func _on_Area_body_entered(body):
	if body == Master.Player:
		print("Player hit!!!")

func state_idle(_delta):
	if get_player_spotted():
		delay_state_change(1.5, "", "state_chase")

func state_chase(_delta):
	if get_player_visibility():
		do_chase_player()
	else:
		do_walk()
