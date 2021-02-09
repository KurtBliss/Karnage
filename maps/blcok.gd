extends MeshInstance

var deaths = 4

func _ready():
	pass

func _on_Enemy_died():
	deaths -= 1
	if deaths <= 0:
		queue_free()


func _on_Enemy2_died():
	_on_Enemy_died()
	pass # Replace with function body.


func _on_Enemy3_died():
	_on_Enemy_died()
	pass # Replace with function body.


func _on_Enemy4_died():
	_on_Enemy_died()
	pass # Replace with function body.
