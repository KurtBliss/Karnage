extends Actor
class_name Player

onready var head = $Head
onready var camera = $Head/Camera
var velocity = Vector3()
var camera_x_rotation = 0
var roll_basis 
var head_basis
var is_dashing = false
var bulletLoad = preload("res://entities/bullet.tscn")
var mouse = Mouse.new(3, self, "move_camera")
var rstick_controls = ["look_left", "look_right", "look_up", "look_down"]
var lstick_controls = ["move_left", "move_right", "move_forward", "move_backward"]
var rstick = Stick.new(rstick_controls, 10, self, "move_camera")
var lstick = Stick.new(lstick_controls, 1, self, "move_player")
onready var raycast = $Head/Camera/RayLong
onready var raycast_hit = $Head/Camera/RayShort
var score = 0 setget score_set
signal score_update(new_score)


func _ready():
	Master.Player = self
	add_to_group("Player")
	add_child(mouse)
	add_child(rstick)
	add_child(lstick)
	$Anime.play("walk", -1, 2)



func _physics_process(delta):
	if $Anime.is_playing() and ($Anime.current_animation == "roll" or $Anime.current_animation == "rollside"):
		is_dashing = true
	else:
		head_basis = head.get_global_transform().basis
		is_dashing = false
		$Anime.play("walk")
	
	var move_z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	var move_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var direction = Vector3()
	direction += head_basis.z * move_z
	direction += head_basis.x * move_x
	
	if Input.is_action_just_pressed("debugEnemy"):
		print("z ", head_basis.z, " x ", head_basis.x)
	
	if Input.is_action_just_pressed("fire"):
		fire()

	if Input.is_action_just_pressed("hit"):
		hit()
	
	if Input.is_action_just_pressed("roll"):
		if $Anime.roll_animation($Head.rotation_degrees, move_z, move_x) != 0:
			roll_basis = head_basis
	
	$Anime.playback_speed = 1 if abs(velocity.z)>1 or abs(velocity.z)>1 else 0
	
	var dash_boast = 2.4 if is_dashing else 1
	
	velocity = velocity.linear_interpolate(direction * speed * dash_boast, acceleration * delta )
	
	if is_on_floor():
		velocity.y = 0
		if Input.is_action_just_pressed("jump"):
			velocity.y += jump_power
	else:
		velocity.y -= gravity
	
	velocity = move_and_slide(velocity, Vector3.UP)


func move_camera(look, delta):
	look *= delta * 15
	head.rotate_y(deg2rad(-look.x))
	var x_delta = look.y
	if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90: 
		camera.rotate_x(deg2rad(-x_delta))
		camera_x_rotation += x_delta



func fire():
	$Head/Camera/Pistol/Anime.seek(0)
	$Head/Camera/Pistol/Anime.play("Fire", -1, 2)
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.is_in_group("Enemy"):
			collider.health -= 25
		elif collider.is_in_group("DeathSpawn"):
			print("DeathSpawn")
			collider.hit()



func hit():
	$Head/Camera/Pistol/Anime.seek(0)
	$Head/Camera/Pistol/Anime.play("Hit", -1, 2)
	if raycast_hit.is_colliding():
		var collider = raycast_hit.get_collider()
		if collider.is_in_group("Enemy"):
			collider.health -= 5
		


func _on_Player_injured():
	print("_on_Player_injured")
	$Hud/Injured/Sprite.modulate.a = 1


func score_set(val):
	score = val
	emit_signal("score_update", val)


func enemy_injured():
	score_set(score + 1)


func enemy_death():
	score_set(score + 50)
	
