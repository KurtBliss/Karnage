extends KinematicBody
# death_spawn_mesh.gd

signal Spawn

func hit():
	emit_signal("Spawn")
