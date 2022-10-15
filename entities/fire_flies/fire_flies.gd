extends Spatial

onready var times = int(rand_range(10,29))
onready var times_max = 30

func _ready():
	$OmniLight/AnimationPlayer.play("Glow")

func _physics_process(delta):
	times += 1
	if times == 50:
		translate(Vector3(rand_range(-0.2,0.2), rand_range(-0.2,0.2), rand_range(-0.2,0.2)))
		times = int(rand_range(10,29))
		global_translation.y = int(global_translation.y) % 120
