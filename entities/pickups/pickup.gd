extends Area

var curbody = null

export(NodePath) onready var parrent_path
onready var parrent = get_node(parrent_path)

func _ready():
	set_process(false)

func _process(_delta):
	if not Input.is_action_just_pressed("interact"):
		return
		
	var weapons = curbody.Weapons
	if true:#not weapons.has_weapon():
		weapons.add_weapon(parrent.weapon)
		queue_free()

func _on_PistolPickup_body_entered(body):
	if body == Master.Player:
		curbody = body
		set_process(true)

func _on_Area_body_exited(body):
	if body == curbody:
		set_process(false)
