class_name Switch
extends Area
signal switched(on)
onready var anime = $bar_switch/AnimationPlayer
var curbody
var on = false

func _ready():
	anime.play("idle")

func _process(delta):
	if not anime.is_playing():
		if is_instance_valid(curbody):
			if Input.is_action_just_pressed("interact"):
				if on:
					anime.play_backwards("down")
				else:
					anime.play("down")

func _on_Switch_body_entered(body):
	if body is Player:
		curbody = body

func _on_Switch_body_exited(body):
	if body == curbody:
		curbody = null

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "down":
		if on:
			on = false
			emit_signal("switched", on)
		else:
			on = true
			emit_signal("switched", on)
			
