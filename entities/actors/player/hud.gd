class_name Player_Hud
extends Control

onready var Health = $Health
onready var Time = $Time
onready var Score = $Score
onready var Clip = $Clip
onready var Ammo = $Ammo

var debug_lines : Array = []

var gui_clip = 0
var gui_ammo = 0

func _on_Player_health_changed(health):
	if Health:
		Health.set_text(str(floor(health)))

func _on_Timer_time_left(time):
	if Time:
		Time.set_text(str(time))

func _on_Player_score_changed(score):
	if Score:
		Score.set_text(str(score))


func _on_Player_clip_changed(clip):
	if Clip:
		gui_clip = clip
		Clip.set_text(str(gui_clip) + " / " + str(gui_ammo))


func _on_Player_ammo_changed(ammo):
	if Clip:
		gui_ammo = ammo
		Clip.set_text(str(gui_clip) + " / " + str(gui_ammo))
	pass # Replace with function body.


func _draw():
	for line in debug_lines:
		draw_line_3D(line)

func add_debug_line(pos1:Vector3,pos2:Vector3,color:Color=Color.green,width:float = 1.0):
	debug_lines.append([pos1,pos2,color,width])

func hide_all():
	Health.visible = false
	Time.visible = false
	Score.visible = false
	Clip.visible = false

func show_clip():
	Clip.visible = true

func show_time():
	Time.visible = true

func show_score():
	Score.visible = true

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
	var camera:Camera = ref.player.camera
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


