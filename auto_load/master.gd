extends Node
# master.gd

var Player # Init on player _ready()
var Manager # Init on manager _ready()
var GameWorld # Init on Nav _ready()
var GameTimer # Init on GameTimer _ready()
var console # Init on Console _ready()
var mute = false
onready var CmdManager = load("res://auto_load/CmdManager.gd")

func _process(_delta):
	if Input.is_action_just_pressed("game_end"):
		if Mouse.toggle and Mouse.capture:
			Mouse.set_toggle(false)
		else:
			get_tree().quit()
	
	OS.set_window_title("Karnage " + str(Engine.get_frames_per_second()))
	
	if Input.is_action_just_pressed("mute"):
		mute = !mute
		var bus_index = AudioServer.get_bus_index("Master")
		AudioServer.set_bus_mute(bus_index, mute)

func reparent(child: Node, new_parent: Node):
	#https://godotengine.org/qa/9806/reparent-node-at-runtime
	var old_parent = child.get_parent()
	old_parent.remove_child(child)
	new_parent.add_child(child)

func enter_command(command:String):
	command = CmdHelp.clean_cmd(command)
	var words : PoolStringArray = command.split(" ",false)
	if words.size()<=0:
		return
	CmdManager.execute_command(words)

func printerror(text:String):
	printerr(text)
	println(text,Color.red)

func println(text:String,color:Color = Color.white):
	console.print_output(text,color)
	pass
