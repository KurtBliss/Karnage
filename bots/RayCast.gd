extends RayCast


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	return
	
	if Master.Player == null:
		return
	cast_to = Master.Player.global_transform.origin - global_transform.origin
	cast_to.y += 0.5
	force_raycast_update()
	print(get_collider())
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
