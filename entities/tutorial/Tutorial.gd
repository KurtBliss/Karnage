class_name Tutorial
extends Control
onready var label = $Label
onready var visible_char_timer = $Char_Increase
var visible_chars = -1
var message_que = []
var msg_shown = false
var last_msg_id

var message = {
	"Welcome": "Welcome to Karnage! ",
	
	"Movement": "Use WASD to move \nMouse to look...\n  ",
	
	"BlueLights": "Walk up to blue lights \nfor these tutorial messages",

	"WeaponPickup": "Use E to pickup weapons",
	
	"M16Pickup": "Left mouse button to shoot,",
	
	"act_like_you_done_this": "\nR to reload\nWeapons ammo is shown on the bottom left  ",
	
	"Done": "When you're ready\n press escape",
	
	"": ""
}
		
func _ready():
	message_update("Welcome", true)
	message_que.append("Movement")
	ref.tutorial = self

func _process(delta):
	if label.visible_characters > label.text.length() + 20:
		if message_que.size() > 0:
			message_update(message_que[0])
			message_que.remove(0)
	match last_msg_id:
		"M16Pickup":
			
			if Input.get_action_strength("fire"):
				message_update("act_like_you_done_this")
				pass
			pass
		_: pass

func _triggered_point(trig):
	match trig.name:
		"WeaponPickup":
			message_update("WeaponPickup", true)
			message_que.append("M16Pickup")
			ref.player.Hud.show_clip()
		_:message_update(trig.msg_name, trig.que)

func message_update(id, que = false):
	if not id == null:
		if message.has(id):
			last_msg_id = id
			label.text = message[id]
			label.visible_characters = 0
		else:
			last_msg_id = ""
			label.text = ""
			label.visible_characters = 0
	if que == false:
		message_que = []

func _on_Char_Increase_timeout():
	label.visible_characters += 1

func _on_Start_pressed():
	visible = true
	call_deferred("stopTimer")

func stopTimer():
#	ref.player.Hud.visible = false
	ref.player.Hud.hide_all()
	ref.level_timer.stop()
	visible_char_timer.start()



func _on_Button_pressed():
	get_tree().change_scene("res://entities/screens/tiledscreen/titled_screen.tscn")
