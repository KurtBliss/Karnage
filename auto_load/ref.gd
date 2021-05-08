"""ref.gd"""
class_name Ref
extends Node

var player : Player # Init on player _ready()
var manager : Manager # Init on manager _ready()
var level : Level # Init on Nav _ready()
var level_timer : LevelTimer # Init on GameTimer _ready()
var tutorial : Tutorial
