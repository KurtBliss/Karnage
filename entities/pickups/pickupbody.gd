class_name PickupBody
extends KinematicBody

var velocity = Vector3.ZERO
var moving = false

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
