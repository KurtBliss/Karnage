extends Camera
# pause.gd

export(NodePath) var spawn_player_path
export(String, FILE, "*.tscn") var player_tscn = "res://entities/player.tscn"
enum MODE {IN_GAME, PRE_GAME, POST_GAME}
var current_mode
var health
var score

func _ready():
	Master.Manager = self
	change_mode(MODE.PRE_GAME)

func change_mode(set_mode):
	match set_mode:
		MODE.IN_GAME:
			current_mode = MODE.IN_GAME
			$PreGame.visible = false
			$PostGame.visible = false
			if Master.Player == null:
				var ld = load("res://player/player.tscn")
				var inst = ld.instance()
				get_parent().add_child(inst)
		MODE.PRE_GAME:
			current_mode = MODE.PRE_GAME	
			$PreGame.visible = true
			$PostGame.visible = false
		MODE.POST_GAME:
			current_mode = MODE.POST_GAME
			$PreGame.visible = false
			$PostGame.visible = true

func _on_Start_pressed():
	if current_mode == MODE.PRE_GAME:
		change_mode(MODE.IN_GAME)

func go_to_post(_health, _score):
	health = _health
	score = _score
	change_mode(MODE.POST_GAME)

func _on_Restart_pressed():
	if current_mode == MODE.POST_GAME:
		change_mode(MODE.IN_GAME)
