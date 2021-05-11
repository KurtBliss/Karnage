extends Screen
#
#func _ready():
#	$AnimationPlayer.play("idle")

func game_end(_button) -> void:
	get_tree().quit()
