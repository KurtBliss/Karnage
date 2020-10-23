extends Timer

signal time_left(time_left)

func _process(delta):
	var secs_left = floor(get_time_left())
	var mins_left = 0
	while secs_left >= 60:
		secs_left -= 60
		mins_left += 1
	var zero = "" if secs_left > 9 else "0"
	var time_left = str(mins_left) + " : " + zero + str(secs_left)
	emit_signal("time_left", time_left)


func _on_Timer_timeout():
	pass # Replace with function body.
