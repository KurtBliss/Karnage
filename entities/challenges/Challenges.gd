class_name Challenges
extends VBoxContainer
enum LEVEL {NONE, CORRIDOR, CITY}
export(LEVEL) onready var level
var destroy_on_release = false
var challenges = []
onready var challenge_ld = preload("res://entities/challenges/Challenge.tscn")
var level_not_set = false

###################-BUILT IN-####################

func _ready():
	ref.challenges = self
	update_level_challenges()

func _process(_delta):
	if destroy_on_release:
		if not Input.is_action_pressed("show_challenges"):
			queue_free()
	
	if level_not_set:
		if is_instance_valid(ref.level):
			update_level_challenges(ref.level.challenges_id)
			level_not_set = false
	
	for challenge in challenges:
		if not challenge["done"]:
			if call(challenge["method"], challenge):
				challenge["done"] = true
				challenge["label"].set_done(true)

func update_level_challenges(set = level):
	for child in get_children():
		child.queue_free()
	
	challenges = []
	
	level = set
	
	match set:
		LEVEL.CORRIDOR:
			challenge_add_highscore(2000)
			challenge_add_highscore(1500)
			challenge_add_highscore(1000)
			challenge_add_kills(5)
		LEVEL.CITY:
			challenge_add_highscore(2000)
			challenge_add_highscore(1500)
			challenge_add_highscore(1000)
			challenge_add_kills(10)
		_:
			level_not_set = true

###################-Challenges Add-####################

func challenge_add(title, points = 0, method = ""):
	var label_node = challenge_ld.instance()
	add_child(label_node)
	label_node.set_name(title)
	challenges.append({
		"label": label_node,
		"done": false,
		"method": method,
		"points": points 
	})

func challenge_add_highscore(points):
	challenge_add("Score "+str(points)+" points", points, "method_highscore")

func challenge_add_kills(points):
	challenge_add("Get "+str(points)+" kills", points, "method_kills")

###################-Challenge Methods-####################

func method_highscore(challenge):
	if is_instance_valid(ref.player):
		if ref.player.score >= challenge["points"]:
			return true
	return false

func method_kills(challenge):
	if is_instance_valid(ref.level):
		if ref.level.kills >= challenge["points"]:
			return true
	return false
