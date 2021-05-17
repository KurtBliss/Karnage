"""ChallengeAnimeContainer"""
extends Position2D

onready var challenge_anime_ld = preload("res://entities/challenges/ChallengeAnime.tscn")

func add_challenge_finished():
	var children = get_children()
	for child in children:
		child.
