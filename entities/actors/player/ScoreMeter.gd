""".../Player/ScoreMeter"""
extends Node2D

onready var front = $Front

func set_meter(set):
	front.scale.x = set / 100
