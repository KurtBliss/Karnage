class_name PickupBody
extends KinematicBody
export(NodePath) onready var weapon_path
onready var weapon = get_node(weapon_path) 
var velocity = Vector3.ZERO
var moving = false
var respawn = true
export var pass_clip = -1
onready var area = $Area

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

func _exit_tree():
	if respawn:
		var respawn_ld = preload("res://entities/pickups/RespawnPickup.tscn")
		var inst = respawn_ld.instance()
		get_parent().add_child(inst)
		inst.global_transform.origin = global_transform.origin
		inst.rotation = rotation
		inst.pickup_ld = load(filename)
