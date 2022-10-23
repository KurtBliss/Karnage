class_name Level
extends Navigation

export var level = ""
export(Challenges.LEVEL) var challenges_id
export var unlock_at = 0
var points = 0 setget set_points, get_points
var kills = 0
var kills_since_death = 0
var kill_combo = 0
var deaths = 0
var hits = 0
var misses = 0
var hit_combo = 0
var melees = 0
var melee_combo = 0
var melee_misses = 0
var targets = 0
var target_goal = 0
var secret_area = false
var challenges = []
var loads = {}


###################-BUILT IN-####################
func _ready():
	if not BgmEternalNight.playing:
		BgmEternalNight.play()
	ref.level = self
	done_challenges()

func _exit_tree() -> void:
	BgmEternalNight.stop()
	pass

###################-FUNCS-####################
func set_points(set):
	points = set
	if is_instance_valid(ref.player):
		ref.player.score_set(set)

func get_points():
	return points

func points_gain(gain):
	set_points(get_points()+gain)
	if is_instance_valid(ref.player):
		ref.player._on_points_gained(gain)

func hit_gain():
	hits += 1
	hit_combo += 1

func miss_gain():
	misses += 1
	hit_combo = 0

func melee_gain():
	melees += 1
	melee_combo += 1

func melee_miss_gain():
	melee_misses += 1
	melee_combo = 0

func kills_gain():
	kills += 1
	kills_since_death += 1
	if kills_since_death > kill_combo:
		kill_combo = kills_since_death

func deaths_gain():
	deaths += 1
	kills_since_death = 0

func target_gain():
	targets += 1
	if targets >= target_goal:
		var method = "_on_target_reached"
		if has_method(method):
			call(method)

func done_challenges():
	var level_challenges = GameData.get_level_challenges(level)
	if level_challenges == null:
		return
	for challenge in level_challenges:
		if challenge.done and challenge.group != "":
			for nd in get_tree().get_nodes_in_group(challenge.group):
				nd.queue_free()
	pass

###################-VIRTUAL FUNCS-####################
func _on_enemy_attacked(enemy, _how):
	
	match enemy:
		_:
			if _how.to_lower() == "shotgun":
				points_gain(1)
			else:
				points_gain(5)

func _on_enemy_killed(enemy, _how):
	
	match enemy:
		_:
			points_gain(100)
	kills_gain()

func _on_player_weapon_hit(hit, _weapon_name, _weapon_clip, is_melee): 	
	if is_melee:
		if hit:
			melee_gain()
		else:
			melee_miss_gain()
	else:
		if hit:
			hit_gain()
		else:
			miss_gain()
	
func _on_player_died():
	deaths_gain()

