tool
extends EditorScript

func _run():
	print("./test.gd")
	print("angle_diff() ", angle_diff(0, -720))

func angle_diff(ang0, ang1):
	return ((((ang0 - ang1) % 360) + 540) % 360) - 180;
