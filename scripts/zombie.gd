extends Bot
class_name Zombie
var attack

func _ready():
	add_to_group("Zombie")
	state_reset("state_normal", "")

func state_normal(delta):
	if get_player_visibility():
		set_path_to(Master.Player.global_transform.origin)
		state_reset("", "state_chase")

func state_chase(delta):
	if process_path():
		state_reset("", "state_normal")
	if attack != null:
		attack.health -= delta * 15
		
func _death():
	queue_free()
 
func _on_Area_body_entered(body: Player):
	if body==null or body.name==null: 
		return
	if body.is_in_group("Player"):
		attack = body

func _on_Area_body_exited(body):
	if body==null or body.name==null: 
		return
	print("body exit ", body.name)
	if body == attack:
		attack = null
