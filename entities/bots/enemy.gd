class_name Enemy
extends Bot

var drain_player_on_proximity = true
var enemy_atk_delay_set = 30
var enemy_atk_delay = 0
var wait_for_player = true
onready var starting_origin = transform.origin

func _ready():
	add_to_group("Enemy")
	
func _process(_delta):
	var p = get_player()
	if wait_for_player:
		if p:
			p.connect("fired", self, "_on_fired")
			p.connect("died", self, "_on_player_died")
			wait_for_player = false
	elif p:
		if drain_player_on_proximity:
			drain_player_health(p)

func set_drain_on_proximity(bol):
	drain_player_on_proximity = bol

func drain_player_health(p):
	enemy_atk_delay -= 1
	if get_player_distance() < 7 and enemy_atk_delay<=0:
		p.do_damage(7,self)
		enemy_atk_delay = enemy_atk_delay_set


func _on_fired():
	set_physics_state("state_chase")

func on_alterted():
	if get_physics_state() == "state_idle":
		set_physics_state("state_alert")

func _on_Enemy_died():
	get_player().score += 10
	var ld = load("res://entities/bots/EnemySpawn.tscn")
	var inst = ld.instance()
	inst.transform.origin = starting_origin
	inst.spawn_scene_location = filename
	Master.GameWorld.add_child(inst)
	queue_free()

func _on_attacked_from_Player(_dmg : float = 5):
	on_alterted()
	
func _on_player_died():
	wait_for_player = true
	
func create_respawn():
	var ld = load("res://entities/bots/EnemySpawn.tscn")
	var inst = ld.instance()
	inst.transform.origin = starting_origin
	inst.spawn_scene_location = filename
	Master.GameWorld.add_child(inst)
	queue_free()
