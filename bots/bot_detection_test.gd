extends Bot

func _ready():
	set_path_to_player()

func _physics_process(delta):
	var process = process_path()
	
	if not process:
		set_path_to_player()
