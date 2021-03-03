extends Sprite
# fade.gd

var can_play = true

func _process(_delta):
	if modulate.a > 0:
		modulate.a -= 0.1
		if can_play:
			can_play = false
			$InjuredSound.play()
	else:
		can_play = true


func _on_Player_injured():
	pass # Replace with function body.
