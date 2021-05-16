extends Bot
onready var door = $"../DoorPrincess"
onready var runto = $"../PrincessRunTo"
signal saved()

func _ready():
	set_physics_state("state_idle")

func _physics_process(delta):
	process_velocity(delta)

func state_idle(_delta):
	$Mannequin/Anime.play("Idle")
	if get_player() and get_player_distance() < 30:
		set_physics_state("state_chase")

func state_chase(_delta):
	$Mannequin/Anime.play("Walk")
	if get_player():
		do_chase_player()
	if  get_player() and get_player_distance() > 80:
		set_physics_state("state_idle")

func state_saved(_delta):
	var process = process_path()
	if not process:
		queue_free()

func _on_PrincessDoorArea_body_entered(body):
	if body == self:
		set_path_to(runto.global_transform.origin)
		set_physics_state("state_saved")
		emit_signal("saved")
