class_name ChallengeAnime
extends Position2D

func challenge_anime_finished(title):
	$Challenge.text = title
	$ChallengeAnime.play("goal_finished", -1, 1.3)


func _on_ChallengeAnime_animation_finished(anim_name):
	queue_free()
