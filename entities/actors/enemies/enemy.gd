class_name Enemy
extends Bot

var drain_player_on_proximity = true
var enemy_atk_delay_set = 30
var enemy_atk_delay = 0
var wait_for_player = true
var wandering_timer : Timer
export(float) var wandering_radius:float = 10
onready var starting_origin = transform.origin
var enemyRNG = RandomNumberGenerator.new()
var enemy_tween : Tween
var spawn_position : Vector3

func _ready():
	add_to_group("Enemy")
	spawn_position = transform.origin
	enemyRNG.randomize()
	wandering_timer = NodeHelper.create_timer(self,2,true,true,"WanderingTimer")
	wandering_timer.connect("timeout",self,"wandering_timer_timeout") 
	enemy_tween = Tween.new()
	add_child(enemy_tween)
	
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

func _physics_process(delta):
	process_velocity(delta)
	

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
		set_physics_state("state_chase")
#		set_physics_state("state_alert")

func _on_Enemy_died():
	get_player().score += 10
	var ld = load("res://entities/enemiess/EnemySpawn.tscn")
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
	var ld = load("res://entities/actors/enemies/EnemySpawn.tscn")
	var inst = ld.instance()
	inst.transform.origin = starting_origin
	inst.spawn_scene_location = filename
	Master.GameWorld.add_child(inst)
	queue_free()

func wandering_timer_timeout():
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


