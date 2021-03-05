extends Camera
# pause.gd

export(NodePath) var spawn_player_path
export(String, FILE, "*.tscn") var player_tscn = "res://entities/player.tscn"
enum MODE {IN_GAME, PRE_GAME, POST_GAME, RESPAWN}
var current_mode
var health
var score

onready var PreGame = $PreGame
onready var PostGame = $PostGame
onready var PreGameStart = $PreGame/Start
onready var PostGameRestart = $PostGame/Restart

func _ready():
	Master.Manager = self
	change_mode(MODE.PRE_GAME)

func change_mode(set_mode):
	match set_mode:
		MODE.IN_GAME:
			current_mode = MODE.IN_GAME
			Master.GameTimer.start()
			PreGame.visible = false
			PostGame.visible = false
			if Master.Player == null:
				var ld = load("res://entities/actors/player/player.tscn")
				var inst : KinematicBody = ld.instance()
				
				inst.set_translation( get_parent().get_node("PlayerSpawn").get_translation())
				get_parent().add_child(inst)
		MODE.PRE_GAME:
			current_mode = MODE.PRE_GAME	
			PreGame.visible = true
			PostGame.visible = false
			PreGameStart.has_focus()
		MODE.POST_GAME:
			current_mode = MODE.POST_GAME
			PreGame.visible = false
			PostGame.visible = true
			PostGameRestart.has_focus()

func _process(_delta):
	match current_mode:
		MODE.POST_GAME:
			if Input.is_action_just_pressed("ui_accept"):
				_on_Restart_pressed()
		MODE.PRE_GAME:
			if Input.is_action_just_pressed("ui_accept"):
				_on_Start_pressed()

	

func _on_Start_pressed():
	if current_mode == MODE.PRE_GAME:
		change_mode(MODE.IN_GAME)

func respawn(_health, _score, _pos):
	
	var ld = load("res://entities/actors/player/player.tscn")
	var player : KinematicBody = ld.instance()
	player.health = 100
	player.score = _score
	player.set_translation(_pos)
	
		# get spawn nodes
	var spawn_points = get_tree().get_nodes_in_group("spawn_point")

	# assume the first spawn node is closest
	var nearest_spawn_point = spawn_points[0]

	# look through spawn nodes to see if any are closer
	for spawn_point in spawn_points:
		if spawn_point.get_translation().distance_to(player.get_translation()) < nearest_spawn_point.get_translation().distance_to(player.get_translation()):
			nearest_spawn_point = spawn_point

	# reposition player
#	player.global_position = nearest_spawn_point.global_position
	player.set_translation(nearest_spawn_point.get_translation())
	get_parent().add_child(player)
	

func go_to_post(_health, _score):
	health = _health
	score = _score
	change_mode(MODE.POST_GAME)

func _on_Restart_pressed():
	if current_mode == MODE.POST_GAME:
#		change_mode(MODE.IN_GAME)
		change_mode(MODE.PRE_GAME)
