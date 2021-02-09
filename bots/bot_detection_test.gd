extends Bot

func _ready():
	pass

func _physics_process(delta):
	if !Master.Player:
		return
		
	print(get_player_visibility())
	
