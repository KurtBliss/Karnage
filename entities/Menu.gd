extends Control

func _ready():
	call_deferred("menu")
	pass

func menu():
	print("set_process to false")
	print(Master.Player)
	Master.Player.set_process(false)
