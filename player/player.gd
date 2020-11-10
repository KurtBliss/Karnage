class_name Player
extends Actor
# player.gd, all of player controls and movement

signal score_changed(score)

###################-VARIABLES-####################

var Player:Player
var velocity = Vector3()
var camera_x_rotation = 0
var roll_basis 
var head_basis
var is_dashing = false
var bulletLoad = preload("res://projectiles/bullet.tscn")
var score = 0 setget score_set
# Controls
var mouse = Mouse.new(3, self, "move_camera")
var rstick_controls = ["look_left", "look_right", "look_up", "look_down"]
var lstick_controls = ["move_left", "move_right", "move_forward", "move_backward"]
var rstick = Stick.new(rstick_controls, 10, self, "move_camera")
var lstick = Stick.new(lstick_controls, 1, self, "move_player")
var can_double = true
# Nodes
onready var raycast = $Head/Camera/RayLong
onready var raycast_hit = $Head/Camera/RayShort
onready var head = $Head
onready var camera = $Head/Camera

###################-BUILT IN-####################

func _ready():
	Master.Player = self
	add_to_group("Player")
	add_child(mouse)
	add_child(rstick)
	add_child(lstick)
	$Anime.play("walk", -1, 2)


func _physics_process(delta):
	"""
		Check if dashing
	"""
	var is_playing = $Anime.is_playing()
	var is_roll_normal = $Anime.current_animation == "roll"
	var is_roll_side = $Anime.current_animation == "rollside"
	var is_roll = is_roll_normal or is_roll_side
	if (is_playing && is_roll):
		is_dashing = true
	else:
		is_dashing = false
		head_basis = head.get_global_transform().basis
		$Anime.play("walk")
	
	"""
		Handle motion input
	"""
	var move_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")	
	var move_z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	var direction = Vector3()
	direction += head_basis.z * move_z
	direction += head_basis.x * move_x
	if Input.is_action_just_pressed("roll"):
		if $Anime.roll_animation($Head.rotation_degrees, move_z, move_x) != 0:
			roll_basis = head_basis
	
	# Update walking speed
	$Anime.playback_speed = 1 if abs(velocity.z)>1 or abs(velocity.z)>1 else 0
	
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
	if $JumpCast.is_colliding():
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
	
	"""
		Handle combat
	"""
	if Input.is_action_just_pressed("fire"):
		$Head/Camera/Pistol/Anime.seek(0)
		$Head/Camera/Pistol/Anime.play("Fire", -1, 2)
		$Head/Camera/Pistol/Flash.visible = true
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider.is_in_group("Enemy"):
				collider.health -= 25
			elif collider.is_in_group("DeathSpawn"):
				collider.hit()

	if Input.is_action_just_pressed("hit"):
		$Head/Camera/Pistol/Anime.seek(0)
		$Head/Camera/Pistol/Anime.play("Hit", -1, 2)
		if raycast_hit.is_colliding():
			var collider = raycast_hit.get_collider()
			if collider.is_in_group("Enemy"):
				collider.health -= 5


func move_camera(look, delta):
	look *= delta * 15
	head.rotate_y(deg2rad(-look.x))
	var x_delta = look.y
	if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90: 
		camera.rotate_x(deg2rad(-x_delta))
		camera_x_rotation += x_delta

###################-VIRTUAL FUNCS-####################

func _on_Player_died():
	if Master.Manager != null:
		queue_free()
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Master.Manager.go_to_post(health, score)

func _on_Timer_timeout():
	if Master.Manager != null:
		queue_free()
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Master.Manager.go_to_post(health, score)

func _on_Player_injured():#should change to red flash
	$Hud/Injured/Sprite.modulate.a = 1

func enemy_injured():
	score_set(score + 1)

func enemy_death():
	score_set(score + 50)


func score_set(value):
	score = value
	emit_signal("score_changed", value)
