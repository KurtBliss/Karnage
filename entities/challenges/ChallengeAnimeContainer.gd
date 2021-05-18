class_name ChallengeAnimeContainer
extends Position2D

onready var challenge_anime_ld = preload("res://entities/challenges/ChallengeAnime.tscn")

func _ready():
	ref.challenge_anime_container = self

func add_challenge_finished(title):
	var pos = 0
	var children = get_children()
	for child in children:
		pos += 1
		child.get_node("ChallengeAnime").seek(0)
	var inst = challenge_anime_ld.instance()
	add_child(inst)
	inst.global_position.y += 32 * pos
	inst.challenge_anime_finished(title)
