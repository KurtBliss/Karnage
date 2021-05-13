class_name Enemy
extends Bot

onready var snd_impact_ld = preload("res://assets/freesounds/511194__pablobd__headshot.tscn")

enum ENEMY {
	MANNEQUIN, MARKSMEN
}
var EnemyNames = {
	ENEMY.MANNEQUIN: "Mannequin",
	ENEMY.MARKSMEN: "Marksmen"
}

export(ENEMY) var enemy
var enemy_name = EnemyNames[enemy]

export(float) var wandering_radius:float = 10

onready var starting_origin = transform.origin

var drain_player_on_proximity = true
var wait_for_player = true
var wandering_timer : Timer
var enemy_atk_delay_set = 30 #TODO: Should make this timer
var enemy_atk_delay = 0
var enemy_tween : Tween
var spawn_position : Vector3
var enemyRNG = RandomNumberGenerator.new()
export var anger = 0

###################-BUILT IN-####################

func _ready():
	add_to_group("Enemy")
	spawn_position = transform.origin
	enemyRNG.randomize()
	wandering_timer = NodeHelper.create_timer(self,2,true,true,"WanderingTimer")
	wandering_timer.connect("timeout",self,"_on_wandering_timer_timeout") 
	enemy_tween = Tween.new()
	add_child(enemy_tween)

func _process(_delta):
	var p = get_player()
	
#	if not is_instance_valid(p):
#		wait_for_player = true
	
	if wait_for_player:
		
		if is_instance_valid(p):
			if p.health > 0:
				p.connect("fired", self, "_on_fired")
				p.connect("died", self, "_on_player_died")
				wait_for_player = false
	elif is_instance_valid(p):
		if drain_player_on_proximity:
			do_drain_player_health(p)
	else:
		wait_for_player = true

func _physics_process(delta):
	process_velocity(delta)


###################-FUNCS-####################

func do_altert(): 
	if get_physics_state() == "state_idle":
		set_physics_state("state_chase")

func set_drain_on_proximity(bol):
	drain_player_on_proximity = bol

func do_drain_player_health(p):
	enemy_atk_delay -= 1
	if get_player_distance() < 3.5 and enemy_atk_delay<=0:
		p.do_damage(7,self)
		enemy_atk_delay = enemy_atk_delay_set

func create_respawn():
	var ld = load("res://entities/actors/enemies/EnemySpawn.tscn")
	var inst = ld.instance()
	inst.transform.origin = starting_origin
	inst.spawn_scene_location = filename
	ref.level.add_child(inst)
	queue_free()

###################-VIRTUAL FUNCS-####################

func _on_fired(): # Hears gunshot
	if get_player():
		if get_player_distance() < 35 or get_player_visibility():
			set_physics_state("state_chase")

func _on_attacked(_dmg):
	var b = blood_decal.instance()
	if is_on_floor():
		ref.level.add_child(b)
		b.global_transform.origin = global_transform.origin 
	
	blood.emitting = true
	blood_delay = 30
	
	var snd = snd_impact_ld.instance()
	add_child(snd)

func _on_attacked_from_Player(dmg, how):
	anger += dmg
	do_altert()
	
	ref.level._on_enemy_attacked(ENEMY, how)
	
func _on_attacked_killed_from_Player(_dmg, how):
	ref.level._on_enemy_killed(ENEMY, how)	

func _on_player_died():
	state_reset("", "state_idle")
	wait_for_player = true

func _on_wandering_timer_timeout(): 
	#TODO: Wandering State State?
	#TODO: Put basic states on enemy.gd, then overide or add to states in children
	if get_physics_state() == "state_idle":
		wandering_timer.wait_time = enemyRNG.randf_range(4,8)
		
		var wandering_position = Vector3(
			spawn_position.x+enemyRNG.randf_range(-wandering_radius,wandering_radius),
			spawn_position.y,
			spawn_position.z+enemyRNG.randf_range(-wandering_radius,wandering_radius))
		
		var previous_rot = rotation
		
		look_at(wandering_position,Vector3.UP)
		
		var rotation_y = wrapf(rotation.y,-PI,PI)
		rotation = previous_rot
		rotation.y = wrapf(rotation.y,-PI,PI)
		
		var dif = rotation_y - rotation.y
		if dif < -PI:
			rotation_y+= TAU
		if dif > PI:
			rotation_y-= TAU
		var absdif = abs(rotation_y - rotation.y)
		
		enemy_tween.interpolate_property(self,"rotation:y",rotation.y,rotation_y,absdif/6,Tween.TRANS_LINEAR)
		enemy_tween.start()
		yield(enemy_tween,"tween_completed")
		wandering_timer.start()
		set_path_to(wandering_position)
