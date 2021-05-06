extends RigidBody

func _ready():
	visible = false
	rotate_y(rand_range(0, 359))
	if not GameSettings.opt_keep_get():
		$Timer.start()

func _on_Timer_timeout():
	queue_free()

func _on_Timer2_timeout():
	visible = true
