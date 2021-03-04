extends MeshInstance

onready var UseMedKit = $UseMedKit

func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		Master.Player.set_health(Master.Player.get_health() + 25)
		UseMedKit.play()
		visible = false


func _on_UseMedKit_finished():
	queue_free()
