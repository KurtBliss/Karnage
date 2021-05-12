class_name Door
extends Position3D
onready var mesh = $Mesh
var bodies = []
var pos = 0
export var locked = false

func _ready():
	pass

func _process(delta):
	if locked:
		pos = 0
	mesh.transform.origin.y = pos
	if bodies.size() == 0:
		if pos > 0:
			pos -= delta * 30
		elif pos < 0:
			pos = 0
	else:
		if pos < 7:
			if not $Open.is_playing():
				$Open.play(1.05)
			pos += delta * 30
		elif pos > 7:
			pos = 7

func _on_Area_body_entered(body):
	
	if body.is_in_group("actor"):
		bodies.append(body)

func _on_Area_body_exited(body):
	var i = 0
	for b in bodies:
		if body == b:
			bodies.remove(i)
			return
		i+=1
