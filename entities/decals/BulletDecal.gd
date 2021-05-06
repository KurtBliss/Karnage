extends Spatial

func _ready():
	if not GameSettings.opt_keep_get():
		$Timer.start()

func _on_Timer_timeout():
	queue_free()
