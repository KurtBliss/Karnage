extends Spatial


onready var zombie = preload("res://entities/zombie.tscn")


func _on_Mesh_Spawn():
	print("DEATH")
	var ins = zombie.instance()
	ins.global_transform.origin = global_transform.origin
	get_parent().add_child(ins)
	pass # Replace with function body.