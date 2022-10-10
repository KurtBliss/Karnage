class_name Challenges
extends VBoxContainer
enum LEVEL {NONE, CORRIDOR, CITY}
export(LEVEL) onready var level
var destroy_on_release = false
var challenges = [] 
onready var challenge_ld = preload("res://entities/challenges/Challenge.tscn")
export var level_not_set = false
export var main = false

###################-BUILT IN-####################

func _ready():
	ref.challenges = self
	if level != LEVEL.NONE:
		update_level_challenges()

func _process(_delta):
	if destroy_on_release:
		if not Input.is_action_pressed("show_challenges"):
			queue_free()
	
	if level_not_set:
		if is_instance_valid(ref.level):
			update_level_challenges(ref.level.challenges_id)
			level_not_set = false
	
	if not main and is_instance_valid(ref.level):
		for challenge in challenges:
			if not is_instance_valid(challenge["label"]):
				remove_challenges()
		if not ref.level.challenges == challenges:
			remove_challenges()
			challenges = ref.level.challenges
			update_challenge_labels()
			
	
	if main == true:
		for challenge in challenges:
			if not challenge["done"]:
				if call(challenge["method"], challenge):
#					print(challenge["label"].text)
					print(challenge["title"])
					ref.challenge_anime_container.add_challenge_finished(challenge["title"])
					
					challenge["done"] = true
					if not is_instance_valid(challenge["label"]):
						update_challenge_labels()
					challenge["label"].set_done(true)
		if is_instance_valid(ref.level):
			ref.level.challenges = challenges

func remove_labels():
	for child in get_children():
		child.queue_free()

func remove_challenges():
	for child in get_children():
		child.queue_free()
	challenges = []

func update_level_challenges(set = level):
	remove_challenges()
	level = set
	match set:
		LEVEL.CORRIDOR:
			var challenges = GameData.get_level_challenges(LEVEL.CORRIDOR)
			
			challenge_add_highscore(1000)
			challenge_add_highscore(1500)
			challenge_add_highscore(2000)
			challenge_add_kills(7)
			challenge_add("Shoot all 4 targets", 4, "method_targets")
			challenge_add("Find the secret room", 1, "method_secret_area")
#			challenge_add("TODO: Shotgun blast then pan enemy", 1, "method_princess")
			challenge_add("Save the princess", 1, "method_princess")
			
			
			
		LEVEL.CITY:
			challenge_add_highscore(2000)
			challenge_add_highscore(1500)
			challenge_add_highscore(1000)
			challenge_add_kills(10)
		_:
			level_not_set = true

func update_challenge_labels():
	remove_labels()
	for challenge in challenges:
		var label_node = challenge_ld.instance()
		label_node.set_name(challenge["title"])
		add_child(label_node)
		challenge["label"] = label_node
		challenge["label"].set_done(challenge["done"])

###################-Challenges Add-####################

func challenge_add(title, points = 0, method = ""):
	var label_node = challenge_ld.instance()
	add_child(label_node)
	label_node.set_name(title)
	challenges.append({
		"label": label_node,
		"title": title,
		"done": false,
		"method": method,
		"points": points
	})

func challenge_add_highscore(points):
	challenge_add("Score "+str(points)+" points", points, "method_highscore")

func challenge_add_kills(points):
	challenge_add("Get "+str(points)+" kills without dying", points, "method_kills")

###################-Challenge Methods-####################

func method_highscore(challenge):
	if is_instance_valid(ref.player):
		if ref.player.score >= challenge["points"]:
			return true
	return false

func method_kills(challenge):
	if is_instance_valid(ref.level):
		if ref.level.kill_combo >= challenge["points"]:
			return true
	return false

func method_targets(challenge):
	if is_instance_valid(ref.level):
		if ref.level.targets >= challenge["points"]:
			return true
	return false

func method_secret_area(challenge):
	if is_instance_valid(ref.level):
		if ref.level.secret_area:
			return true
	return false

func method_princess(_challenge):
	if is_instance_valid(ref.level):
		if ref.level.princess_saved:
			return true
	return false
