extends KinematicBody
onready var draw = $ImmediateGeometry

var move = false
var path = []
var path_ind = 0
var points = []
var point_ld = preload("res://entities/unit/Point.tscn")

func _physics_process(delta):
	if Input.is_action_just_pressed("test"):
		set_path_to(ref.player.global_transform.origin)
		move = true
		
	if move:
		#get the next position
		if path_ind < path.size() - 1:
			while (path[path_ind] - global_transform.origin).length() < 1:
				path_ind += 1
		var next = path[path_ind]
		#work out velocity
		var velocity = (next - global_transform.origin).normalized() * 5 * delta
		#now move
		move_and_collide(velocity)
	

func set_path_to(target_pos):
	path = ref.level.get_simple_path(global_transform.origin, target_pos)
	path_ind = 0
	
	for point in points:
		if is_instance_valid(point):
			point.queue_free()
	
	for point in path:
		var inst = point_ld.instance()
		get_parent().add_child(inst)
		inst.global_transform.origin = point
		points.append(inst)
