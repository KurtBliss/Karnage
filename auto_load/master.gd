"""master.gd"""
extends Node
var console # Init on Console _ready()
var mute = false
onready var CmdManager = load("res://auto_load/Console/CmdManager.gd")
var quit_timer = 0

enum AMMO {PISTOL, M16, SHOTGUN, SNIPER}

var ammo_container = {
	AMMO.PISTOL: 0,
	AMMO.M16: 0,
	AMMO.SHOTGUN: 0,
	AMMO.SNIPER: 0
}

func _ready() -> void:
	#mute = !mute
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_index, mute)

func _process(_delta):
	if Input.is_action_pressed("game_end"):
		quit_timer += _delta
		if  quit_timer > 1:
			get_tree().quit()
	else:
		quit_timer = 0
	
	OS.set_window_title("Karnage " + str(Engine.get_frames_per_second()))
	
	if Input.is_action_just_pressed("mute"):
		GameSettings.opt_mute_toggle()

func input_disabled():
	if Console.visible:
		return true
	return false

func input_enabled():
	return !input_disabled()

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

func _enter_tree() -> void:
	GameData.load_data()

func _exit_tree() -> void:
	GameData.save()
