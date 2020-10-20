extends Control

func _on_Body_set_health(health):
	$Health.set_text(str(floor(health)))
