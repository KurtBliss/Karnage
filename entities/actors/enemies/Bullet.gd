extends RigidBody
var shoot = false
export(String, "None", "Enemy", "Player") var target_group
export onready var speed = 1
export onready var damage = 15

func _ready():
	set_as_toplevel(true)
	$GunShotSound.set_as_toplevel(true)

func _physics_process(_delta):
	apply_impulse(transform.basis.z, -transform.basis.z * speed)

func _on_Area_body_entered(body):
	if body.is_in_group(target_group):
		body.do_damage(damage, self)
	queue_free()
