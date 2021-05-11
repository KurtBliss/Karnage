extends Sprite
# fade.gd
onready var InjuredSound = $InjuredSound

var can_play = false
var health = 100

func _ready():
	 modulate.a = 0

func _process(_delta):
	if modulate.a > 0:
		modulate.a -= 0.1
		if not $InjuredPlayer.is_playing():
			can_play = false
			var lv = "0"
			if health < 75:
				lv = "1"
			if health < 50:
				lv = "2"
			if health < 25:
				lv = "3"
			$InjuredPlayer.play("Hurt"+lv)
	else:
		rotation_degrees = rand_range(0, 359)
		can_play = true


func _on_player_hurt(amount):
	health = amount
	modulate.a = 1

func _on_Player_injured():
	pass # Replace with function body.


func _on_InjuredPlayer_animation_finished(anim_name):
	$InjuredPlayer.stop()
	pass # Replace with function body.
