class_name Player
extends Actor
# player.gd, all of player controls and movement

signal score_changed(score)
signal fired()
signal clip_changed(clip)
signal ammo_changed(ammo)

###################-VARIABLES-####################

var Player:Player
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
var ammo = Master.ammo_container

# Nodes
onready var raycast = $Head/Camera/RayLong
onready var raycast_hit = $Head/Camera/RayShort
onready var head = $Head
onready var camera = $Head/Camera
#export(NodePath) 
onready var Weapons = $"Head/Camera/Weapon"
onready var Anime = $Anime
onready var Hud : Player_Hud = $Hud
onready var JumpCast = $JumpCast
onready var Weapon = $Head/Camera/Weapon
onready var InjuredSprite = $Hud/Injured/Sprite

###################-BUILT IN-####################

func _ready():
	
	ref.player = self
	prints("ref.player", ref.player)
	
	Mouse.set_capture(true)
	add_child(rstick)
	add_to_group("Player")
	ref.level_timer.connect("timeout", self,  "_on_Timer_timeout")
	ref.level_timer.connect("time_left", Hud, "_on_Timer_time_left")
	ammo[Master.AMMO.PISTOL] += 10
	ammo[Master.AMMO.M16] += 32
	
	
	

func _physics_process(delta):
	var can_input = Master.input_enabled()
	"""
		Check if dashing
	"""
	var is_playing = Anime.is_playing()
	var is_roll_normal = Anime.current_animation == "roll"
	is_roll_normal = is_roll_normal || Anime.current_animation == "roll back"
	var is_roll_side = Anime.current_animation == "rollside"
	is_roll_side = is_roll_side || Anime.current_animation == "roll left"
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
	var move_x
	var move_z
	if can_input:
		move_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")	
		move_z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	else:
		move_x = 0
		move_z = 0
	var direction = Vector3()
	direction += head_basis.z * move_z
	direction += head_basis.x * move_x
	
	if Input.is_action_just_pressed("roll") and can_input:
		if Anime.roll_animation(head.rotation_degrees, move_z, move_x) != 0:
			roll_basis = head_basis
	
	
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
		if Input.is_action_just_pressed("jump") and can_input:
			can_double = true
			velocity.y += jump_power
	else:
		if Input.is_action_just_pressed("jump") and can_input and can_double:
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
	
func do_emit_clip(clip):
	#to get rid of cautoin in log
	emit_signal("clip_changed", clip)

func do_emit_ammo(emit_ammo):
	#TODO: to get rid of caution in log
	emit_signal("ammo_changed", emit_ammo)

func gain_ammo(type, amount):
	if ammo[type] != null:
		ammo[type] += amount
	else:
		ammo[type] = amount

###################-VIRTUAL FUNCS-####################

func _on_Player_died():
	
	Weapon.throw_weapon()
	
	if ref.manager != null:
#		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
#			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Mouse.set_capture(false)
		ref.player = null
		queue_free()
		ref.manager.respawn(health, score, get_translation())
		

func _on_Timer_timeout():
	if ref.manager != null:
		queue_free()
#		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
#			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Mouse.set_capture(false)
		ref.manager.go_to_post(health, score)

func _on_Player_injured():#should change to red flash
	InjuredSprite.modulate.a = 1

func enemy_injured():
	score_set(score + 1)

func enemy_death():
	score_set(score + 50)

func score_set(value):
	score = value
	emit_signal("score_changed", value)

func _enter_tree() -> void:
	pass
	# ref.player = self

func _exit_tree() -> void:
	pass
	# ref.player = null
