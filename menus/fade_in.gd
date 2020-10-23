extends ColorRect

signal fade_finished

func fade_in():
	$Anime.play("fade_in")

func _on_Anime_animation_finished(anim_name):
	emit_signal("fade_finished")
