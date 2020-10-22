extends Control

func _on_Player_set_health(health):
	$Health.set_text(str(floor(health)))
