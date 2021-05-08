extends MeshInstance

onready var UseMedKit = $UseMedKit

func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		ref.player.set_health(ref.player.get_health() + 25)
		UseMedKit.play()
		visible = false


func _on_UseMedKit_finished():
	queue_free()
