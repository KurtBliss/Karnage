extends Enemy

export var swing_damage = 0
onready var Anime = $Anime

func _ready(): 
	speed *= 1.5
	set_drain_on_proximity(false)
	set_physics_state("state_idle")

func _process(_delta):
	if Input.is_action_just_pressed("test"):
		print(get_player_visibility())

func _on_Area_body_entered(body):
	if body == Master.Player:
		print("Player HIT ", swing_damage)
		
		if swing_damage > 0:
			swing_damage = 0
			print("Player HIT")
			Master.Player.do_damage(swing_damage, self)

func state_idle(_delta):
	if get_player_spotted():
		set_physics_state("state_chase")
#		delay_state_change(1.5, "", "state_chase")

func state_chase(_delta):
	if get_player_visibility():
		if get_player_distance() < 6:
			if not Anime.current_animation == "attack":
#				$Anime.play("attack")
#				set_physics_state("state_attacking")
				set_physics_state("state_attack")
		do_chase_player()
	else:
		set_path_to_player()
		set_physics_state("state_chase_path")

func state_attack(_delta):
	Anime.play("attack")
	set_physics_state("state_attacking")

func state_attacking(_delta):
	do_face_player()
	pass

func state_chase_path(_delta):
	if get_player_visibility():
		set_physics_state("state_chase")
		return
	var process = process_path()
	if not process:
		set_path_to_player()

func _on_MeleeEnemy_died():
	create_respawn()

func _on_Anime_animation_finished(anim_name):
	if anim_name == "attack":
		set_physics_state("state_chase")
		Anime.play("idle")


func _on_Area_body_exited(_body):
	if swing_damage > 0:
		print("Player HIT")
		Master.Player.do_damage(swing_damage, self)
		swing_damage = 0
