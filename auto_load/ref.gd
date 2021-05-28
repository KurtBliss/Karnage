"""ref.gd"""
class_name RefClass
extends Node

var player : Player # Init on player _ready()
var manager : Manager # Init on manager _ready()
var level : Level # Init on Nav _ready()
var challenges : Challenges
var level_timer : LevelTimer # Init on GameTimer _ready()
var tutorial : Tutorial
var challenge_anime_container : ChallengeAnimeContainer

func is_valid(a):
	if a != null and is_instance_valid(a):
		return true
	return false
