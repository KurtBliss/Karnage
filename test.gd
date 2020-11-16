tool
extends EditorScript

func _run():
	print("./test.gd")
	print("wrap() ", wrap(359+360+360, 0, 360))

func wrap(value, _min, _max):
	var _mod = ( value - _min ) % ( _max - _min )
	if ( _mod < 0 ): 
		return _mod + _max 
	else: 
		return _mod + _min

func angle_diff(ang0, ang1):
	return ((((ang0 - ang1) % 360) + 540) % 360) - 180;
