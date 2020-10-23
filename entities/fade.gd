extends Sprite

func _process(_delta):
	if modulate.a > 0:
		modulate.a -= 0.1
