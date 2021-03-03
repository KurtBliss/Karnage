extends Control
# hud.gd



func _on_Player_health_changed(health):
	$Health.set_text(str(floor(health)))

func _on_Timer_time_left(time):
	$Time.set_text(str(time))

func _on_Player_score_changed(score):
	$Score.set_text(str(score))
