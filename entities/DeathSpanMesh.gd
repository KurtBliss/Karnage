extends KinematicBody

signal Spawn

func hit():
	emit_signal("Spawn")
