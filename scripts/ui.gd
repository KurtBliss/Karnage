extends Control

func _on_Player_set_health(health):
	$Health.set_text(str(floor(health)))


func _on_Timer_time_left(time_left):
	$Time.set_text(str(time_left))
	pass # Replace with function body.
