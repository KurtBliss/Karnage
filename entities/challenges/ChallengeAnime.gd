class_name ChallengeAnime
extends AnimationPlayer
onready var label = $Label

func _ready():
	ref.challenge_anime = self

func challenge_anime_finished(title):
	if label.text != "":
		label.text += "\n"
	label.text += title
	play("goal_finished", -1, 1.3)

func _on_ChallengeAnime_animation_finished(anim_name):
	label.text = ""
