extends Bot

func _ready():
	set_path_to_player()

func _physics_process(delta):
	if !Master.Player:
		return
	
	if Master.debug_enemy():
		print(detect_facing_self(Master.Player, 23))
#		print(wrap(rotation_degrees.y, 0, 359))
	
#	var process = process_path()
#
#	if not process:
#		set_path_to_player()
