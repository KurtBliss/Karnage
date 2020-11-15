extends RayCast
var P : Player
var player_is_visible = false
var offsety = 0

func _process(_delta):
	offsety += int(Input.is_action_just_pressed("ui_down")) - int(Input.is_action_just_pressed("ui_up")) * 0.1
	
	player_is_visible = false
	
	if Master.Player:
		set_enabled(true)
		P = Master.Player
		var pos = P.global_transform.origin
		pos.y += offsety
		cast_to = pos-global_transform.origin
		var par : Bot = get_parent()
		set_rotation_degrees(-par.get_rotation_degrees())
#		rotate(-Bot.g) 
	var col = get_collider()
	if col and col.is_in_group("Player"):
		player_is_visible = true
