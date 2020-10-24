extends Control

func _ready():
	call_deferred("menu")

func menu():
	Master.Player.set_process(false)
