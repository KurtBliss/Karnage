extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("dumb")
	pass # Replace with function body.

func dumb():
	get_parent().set_physics_state("state_dumb")
	get_parent().respawn = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
