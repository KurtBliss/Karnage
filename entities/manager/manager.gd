class_name Manager
extends Camera
# pause.gd

export(NodePath) var spawn_player_path
export(String, FILE, "*.tscn") var player_tscn = "res://entities/player.tscn"
enum MODE {IN_GAME, PRE_GAME, POST_GAME, PRE_GAME_CHALLENGES}
var current_mode
var health
var score
var wait_for_level = true

var levels = [
	"res://maps/Tutorial.tscn",
	"res://maps/Corridor.tscn",
	"res://maps/City.tscn",
	"res://maps/Alpha.tscn"
]
var levelsNames = [
	"Tutorial",
	"Corridor",
	"City", 
	"Alpha"
]
var level_index = -2

onready var PreGame = $PreGame
onready var PostGame = $PostGame
onready var PreGameStart = $PreGame/Start
onready var PostGameRestart = $PostGame/Restart

func _ready():
	ref.manager = self
	change_mode(MODE.PRE_GAME)
	$AnimationPlayer.play("fastSpin")



func _process(_delta):
	if wait_for_level:
		if is_instance_valid(ref.level):
			level_index = levels.find(ref.level.filename)
			
			var n = level_index + 1
			if n >= levels.size():
				n = 0
			$PreGame/Next.text = levelsNames[n]
			
			var p = level_index - 1
			if n < 0:
				n = levels.size() - 1
			$PreGame/Previous.text = levelsNames[p]
			
			$PreGame/Level.text = ref.level.level
			
			$PostGame/Finished.text = ref.level.level
			
			$PostGame/Challenges.update_level_challenges(ref.level.challenges_id)
			$PreGame/Challenges.update_level_challenges(ref.level.challenges_id)
			wait_for_level = false
	
	if Master.input_disabled():
		return
	
	match current_mode:
		MODE.POST_GAME:
			pass
#			if Input.is_action_just_pressed("ui_accept"):
#				_on_Restart_pressed()
		MODE.PRE_GAME:
			pass
#			if Input.is_action_just_pressed("ui_accept"):
#				_on_Start_pressed()
#			if Input.is_action_just_pressed("ui_right"):
#				map_next()
#			if Input.is_action_just_pressed("ui_left"):
#				map_previous()

func map_next():
	var findcurrent = levels.find(ref.level.filename)
	if findcurrent > -1:
		var goto = findcurrent + 1
		if goto >= levels.size():
			goto = 0
		get_tree().change_scene(levels[goto])

func map_previous():
	var findcurrent = levels.find(ref.level.filename)
	if findcurrent > -1:
		var goto = findcurrent - 1
		if goto < 0:
			goto = levels.size() - 1
		get_tree().change_scene(levels[goto])

func change_mode(set_mode):
	match set_mode:
		MODE.IN_GAME:
			current_mode = MODE.IN_GAME
			ref.level_timer.start()
			PreGame.visible = false
			PostGame.visible = false
			if ref.player == null or not is_instance_valid(ref.player):
				var ld = load("res://entities/actors/player/player.tscn")
				var inst : Player = ld.instance()
				
				inst.set_translation( get_parent().get_node("PlayerSpawn").get_translation())
				get_parent().add_child(inst)
				

		MODE.PRE_GAME:
			current_mode = MODE.PRE_GAME	
			PreGame.visible = true
			PostGame.visible = false
			PreGameStart.grab_focus()
		MODE.POST_GAME:
			current_mode = MODE.POST_GAME
			PreGame.visible = false
			PostGame.visible = true
			PostGameRestart.grab_focus()
			var lv = ref.level.level
			var hs = 0
			if is_instance_valid(GameData):
				hs = GameData.get_level_highscore(lv)
				if score > hs:
					GameData.set_level_highscore(ref.level.level, score)
				GameData.save()
			set_stat("Score", score)
			set_stat("Highest Score", hs)
			set_stat("Kills", ref.level.kills)
			set_stat("Highest Combo", ref.level.kill_combo)
			set_stat("Deaths", ref.level.deaths)


func set_stat(prop, value):
	var nd = $PostGame/Stats.get_node(prop)
	nd.text = prop + ": " + String(value)
	return nd

func _on_Start_pressed():
	if current_mode == MODE.PRE_GAME:
		change_mode(MODE.IN_GAME)

func respawn(_health, _score, _pos):
	var ld = load("res://entities/actors/player/player.tscn")
	var player : KinematicBody = ld.instance()
	player.health = 100
	player.score = _score
	player.set_translation(_pos)
	
	var spawn_points = get_tree().get_nodes_in_group("spawn_point")

	var nearest_spawn_point = spawn_points[0]

	for spawn_point in spawn_points:
		if spawn_point.get_translation().distance_to(player.get_translation()) < nearest_spawn_point.get_translation().distance_to(player.get_translation()):
			nearest_spawn_point = spawn_point

	player.set_translation(nearest_spawn_point.get_translation())
	get_parent().add_child(player)
	ref.player = player

func go_to_post(_health, _score):
	health = _health
	score = _score
	change_mode(MODE.POST_GAME)

func _on_Restart_pressed():
	if current_mode == MODE.POST_GAME:
		get_tree().reload_current_scene()

func _on_ButtonPrev_pressed():
	map_previous()

func _on_ButtonNext_pressed():
	map_next()


func _on_ButtonNext_focus_entered():
	map_next()
	pass # Replace with function body.


func _on_ButtonPrev_focus_entered():
	map_previous()
	pass # Replace with function body.


func _on_Exit_pressed():
	get_tree().change_scene("res://entities/screens/tiledscreen/titled_screen.tscn")
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fastSpin":
		$AnimationPlayer.play("mapsSpin")
