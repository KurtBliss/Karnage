"""Autoload/game_settings.gd"""
extends Node

func _ready():
	var apply_methods = get_method_list()
	for method in apply_methods:
		var temp_name = method.name
		if method.name.ends_with("_apply"):
			call(temp_name)
	
	var temp : String
	temp.ends_with("_apply")

func opt_fullscreen_toggle() -> void:
	GameData.settings["fullscreen"] = !GameData.settings["fullscreen"]
	opt_fullscreen_apply()

func opt_fullscreen_get() -> bool:
	return GameData.settings["fullscreen"]

func opt_fullscreen_apply() -> void:
	OS.window_fullscreen = bool(GameData.settings["fullscreen"])


