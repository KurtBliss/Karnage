extends Sprite
# fade.gd

func _process(_delta):
	if modulate.a > 0:
		modulate.a -= 0.1
