class_name PickupBody
extends KinematicBody

export(NodePath) onready var weapon_path
onready var weapon = get_node(weapon_path) 

var velocity = Vector3.ZERO
var moving = false

export var pass_clip = -1

func _ready() -> void:
	if pass_clip > -1:
		weapon.clip = pass_clip

func _physics_process(_delta):
	velocity = lerp(velocity, Vector3(0, velocity.y, 0), 0.05)
	
	if velocity != Vector3.ZERO:
		if moving == false:
			moving = true
	
	if moving:
		if is_on_floor():
			velocity.y = 0
		else:
			velocity.y -= 0.98
	
	velocity = move_and_slide(velocity, Vector3.UP)
	
	weapon.rotation.y += 0.1
