extends RigidBody

var shoot = false

const DAMAGE = 50
const SPEED = 1

func _ready():
	set_as_toplevel(true)
	$GunShotSound.set_as_toplevel(true)

func _physics_process(_delta):
#	if shoot:
		apply_impulse(transform.basis.z, -transform.basis.z * SPEED)

func _on_Area_body_entered(body):
	if body == Master.Player:
		Master.Player.do_damage(15, self)
	queue_free()