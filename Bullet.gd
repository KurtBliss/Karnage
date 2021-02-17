extends RigidBody

var shoot = false

const DAMAGE = 50
const SPEED = 10

func _ready():
	set_as_toplevel(true)

func _physics_process(delta):
#	if shoot:
		apply_impulse(transform.basis.z, -transform.basis.z * SPEED)

func _on_Area_body_entered(body):
	if body == Master.Player:
		Master.Player.do_damage(15, self)
	queue_free()
