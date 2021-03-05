class_name Player
extends Actor
# player.gd, all of player controls and movement

signal score_changed(score)
signal fired()

###################-VARIABLES-####################

var Player:Player
var velocity = Vector3()
var camera_x_rotation = 0
var roll_basis 
var head_basis
var is_dashing = false
# var bulletLoad = preload("res://entities/projectiles/bullet.tscn")
var score = 0 setget score_set
var can_double = true
var dir
var rstick_controls = ["look_left", "look_right", "look_up", "look_down"]
var rstick = Stick.new(rstick_controls, 10, self, "move_camera")
# Nodes
onready var raycast = $Head/Camera/RayLong
onready var raycast_hit = $Head/Camera/RayShort
onready var head = $Head
onready var camera = $Head/Camera
#export(NodePath) 
onready var Weapons = $"Head/Camera/Weapon"
onready var Anime = $Anime
onready var Hud = $Hud
onready var JumpCast = $JumpCast
onready var Weapon = $Head/Camera/Weapon
onready var InjuredSprite = $Hud/Injured/Sprite

###################-BUILT IN-####################

func _ready():
	Master.Player = self
	Mouse.set_capture(true)
	add_child(rstick)
	add_to_group("Player")
	Master.GameTimer.connect("timeout", self,  "_on_Timer_timeout")
	Master.GameTimer.connect("time_left", Hud, "_on_Timer_time_left")

func _process(_delta):
	if Input.is_action_just_pressed("show_challenges"):
		var ld = load("res://entities/manager/VBoxContainer.tscn")
		var inst = ld.instance()
		inst.destroy_on_release = true
		add_child(inst)

func _physics_process(delta):
	"""
		Check if dashing
	"""
	var is_playing = Anime.is_playing()
	var is_roll_normal = Anime.current_animation == "roll"
	var is_roll_side = Anime.current_animation == "rollside"
	var is_roll = is_roll_normal or is_roll_side
	if (is_playing && is_roll):
		is_dashing = true
	else:
		is_dashing = false
		head_basis = head.get_global_transform().basis
#		$Anime.play("walk")

	"""
		Handle camera input
	"""
	
	var mot = Mouse.get_motion()
	if mot.x<0 or mot.y<0 or mot.x>0 or mot.y>0:
		move_camera(mot * 3, delta)
#	else:
#		mot = Vector2.ZERO
#		mot.x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left") 
#		mot.y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up") 
#		mot.normalized()
#		mot *= 10
#		move_camera(mot, delta)

	
	"""
		Handle motion input
	"""
	var move_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")	
	var move_z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	var direction = Vector3()
	direction += head_basis.z * move_z
	direction += head_basis.x * move_x
	
	if Input.is_action_just_pressed("roll"):
		if Anime.roll_animation(head.rotation_degrees, move_z, move_x) != 0:
			roll_basis = head_basis
#			$Roll.play()
	
	
	dir = Vector3()
	dir += head_basis.z * -10
	dir += head_basis.x
	
	dir.normalized()
	
	# Update walking speed
#	$Anime.playback_speed = 1 if abs(velocity.z)>1 or abs(velocity.z)>1 else 0
	
	"""
		Handle gravity and movement
	"""
	# Apply speed
	var vector = direction * speed
	if is_dashing:
		vector *= 2.4
	var rate = acceleration * delta 
	velocity = velocity.linear_interpolate(vector, rate)
	
	# Jump
	if JumpCast.is_colliding() or is_on_floor():
		velocity.y = 0
		if Input.is_action_just_pressed("jump"):
			can_double = true
			velocity.y += jump_power
	else:
		if Input.is_action_just_pressed("jump") and can_double:
			can_double = false
			velocity.y += jump_power
		else:
			velocity.y -= gravity
	
	# Collision
	velocity = move_and_slide(velocity, Vector3.UP)
	

func move_camera(look, delta):
	look *= delta * 15
	head.rotate_y(deg2rad(-look.x))
	var x_delta = look.y
	if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90: 
		camera.rotate_x(deg2rad(-x_delta))
		camera_x_rotation += x_delta

func do_emit_fire():
	#to get rid of cautoin in log
	emit_signal("fired")

###################-VIRTUAL FUNCS-####################

func _on_Player_died():
	
	Weapon.throw_weapon()
	
	if Master.Manager != null:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		queue_free()
		
		Master.Manager.respawn(health, score, get_translation())

func _on_Timer_timeout():
	if Master.Manager != null:
		queue_free()
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Master.Manager.go_to_post(health, score)

func _on_Player_injured():#should change to red flash
	InjuredSprite.modulate.a = 1

func enemy_injured():
	score_set(score + 1)

func enemy_death():
	score_set(score + 50)

func score_set(value):
	score = value
	emit_signal("score_changed", value)

func _on_Player_tree_exited():
	Mouse.set_capture(false)
