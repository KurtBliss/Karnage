extends Area
# death.gd

var targets = []

func _on_Death_body_entered(body):
	print_stack()
	print(body)
	if body.is_in_group("Player"):
		print_stack()
		print(body)
		targets.append(body)

func _on_Death_body_exited(body):
	var i = 0
	while i < targets.size():
		if body == targets[i]:
			targets.remove(i)
		else: 
			i += 1

func _physics_process(delta):
	var i = 0
	while i < targets.size():
		if Input.is_action_just_pressed("debugEnemy"):
			print(targets[i])
		targets[i].health -= delta * 10
		i += 1
