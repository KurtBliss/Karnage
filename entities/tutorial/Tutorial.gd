extends Control
onready var label = $Label
onready var visible_char_timer = $Char_Increase
var visible_chars = -1
var message_que = []
var msg_shown = false

var message = {
	"Welcome": "Welcome to Karnage! ",
	
	"Movement": "\nUse WASD keys to move \nMouse to look...\n  ",
	
	"PickupWeapon": "Great job,\n Use the E key to pickup weapons",
	
	"M16Pickup": "Whoooa, good job!\nLeft mouse button to shoot",
	
	"BlueLights": "Walk up to blue lights for these tutorial messages",
	
	"": ""
}
		
func _ready():
	message("Welcome", true)
	message_que.append("Movement")
	Master.Tutorial = self

func _process(delta):
	if label.visible_characters > label.text.length() + 20:
		if message_que.size() > 0:
			message(message_que[0])
			message_que.remove(0)

func _triggered_point(trig):
	match trig.name:
		_:message(trig.msg_name, trig.que)

func message(id, que = false):
	if not id == null:
		if message.has(id):
			label.text = message[id]
			label.visible_characters = 0
		else:
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
	Master.Player.Hud.visible = false
	Master.GameTimer.stop()
	visible_char_timer.start()

