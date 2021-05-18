class_name ChallengeAnimeContainer
extends Position2D

onready var challenge_anime_ld = preload("res://entities/challenges/ChallengeAnime.tscn")

func _ready():
	ref.challenge_anime_container = self

func add_challenge_finished(title):
	var children = get_children()
	for child in children:
		child.seek(0)
	var inst = challenge_anime_ld.instance()
	add_child(inst)
	inst.challenge_anime_finished(title)
