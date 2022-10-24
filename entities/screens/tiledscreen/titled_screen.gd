extends Screen
#
func _ready():
	if GameData.settings["last_level"] != "":
		$Menu/CenterRow/Buttons/New.scene = GameData.settings["last_level"]
#	$AnimationPlayer.play("idle")

func game_end(_button) -> void:
	get_tree().quit()
