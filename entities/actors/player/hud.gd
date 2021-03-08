extends Control

onready var Health = $Health
onready var Time = $Time
onready var Score = $Score



func _on_Player_health_changed(health):
	if Health:
		Health.set_text(str(floor(health)))

func _on_Timer_time_left(time):
	if Time:
		Time.set_text(str(time))

func _on_Player_score_changed(score):
	if Score:
		Score.set_text(str(score))
