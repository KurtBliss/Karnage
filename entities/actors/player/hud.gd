extends Control

onready var Health = $Health
onready var Time = $Time
onready var Score = $Score

var debug_lines : Array = []



func _on_Player_health_changed(health):
	if Health:
		Health.set_text(str(floor(health)))

func _on_Timer_time_left(time):
	if Time:
		Time.set_text(str(time))

func _on_Player_score_changed(score):
	if Score:
		Score.set_text(str(score))


func _draw():
	for line in debug_lines:
		draw_line_3D(line)

func add_debug_line(pos1:Vector3,pos2:Vector3,color:Color=Color.green,width:float = 1.0):
	debug_lines.append([pos1,pos2,color,width])


func draw_line_3D(line:Array):
	var color = Color.green
	var width = 1.0
	if line.size() > 4 || line.size() < 2:
		return
	if line[0] ==null || line[1] ==null :
		return
	if line.size() > 3:
		if line[3] != null:
			width = line[3]
	if line.size() > 2:
		if line[2] != null:
			color = line[2]
	var camera:Camera = Master.Player.camera
	var start = camera.unproject_position(line[0])
	var end = camera.unproject_position(line[1])
	
	var is_start_behind = camera.is_position_behind(line[0])
	var is_end_behind = camera.is_position_behind(line[1])
	if is_start_behind and is_end_behind:
		return
	
	if is_start_behind:
		start = start+((end - start)*2)
	if is_end_behind:
		end = end+((start - end)*2)
	draw_line(start, end, color, width)
