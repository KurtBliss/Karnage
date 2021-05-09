class_name Level
extends Navigation

export var level = ""
var points = 0 setget set_points, get_points
var kills = 0
var hits = 0
var misses = 0
var hit_combo = 0
var melees = 0
var melee_combo = 0
var melee_misses = 0

###################-BUILT IN-####################
func _ready():
	ref.level = self

###################-FUNCS-####################
func set_points(set):
	points = set
	if is_instance_valid(ref.player):
		ref.player.score_set(set)

func get_points():
	return points

func points_gain(gain):
	set_points(get_points()+gain)

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

###################-VIRTUAL FUNCS-####################
func _on_enemy_attacked(enemy):
	match enemy:
		_:
			points_gain(5)

func _on_enemy_killed(enemy):
	match enemy:
		_:
			points_gain(100)
	kills += 1

func _on_player_weapon_hit(hit, _weapon_name, _weapon_clip, is_melee): #TODO: 	
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
	
