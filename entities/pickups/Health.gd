extends MeshInstance

onready var UseMedKit = $UseMedKit

signal grabbed()

var grabbed = false

func _on_Area_body_entered(body):
	if grabbed:
		return
	if body.is_in_group("player"):
		ref.player.set_health(ref.player.get_health() + 25)
		UseMedKit.play()
		visible = false
		grabbed = true
		emit_signal("grabbed")


func _on_UseMedKit_finished():
	queue_free()
