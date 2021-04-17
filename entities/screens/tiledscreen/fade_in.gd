class_name FadeIn
extends ColorRect

onready var Anime = $Anime

signal fade_finished

func fade_in():
	Anime.play("fade_in")

func _on_Anime_animation_finished(_anim_name):
	emit_signal("fade_finished")
