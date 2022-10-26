"""Autoload/game_settings.gd"""
extends Node

var draging = false

func _ready():
	var apply_methods = get_method_list()
	for method in apply_methods:
		var temp_name = method.name
		if method.name.ends_with("_apply"):
			call(temp_name)

# Fullscreen
func opt_fullscreen_toggle() -> void:
	GameData.settings["fullscreen"] = !GameData.settings["fullscreen"]
	opt_fullscreen_apply()

func opt_fullscreen_get() -> bool:
	return GameData.settings["fullscreen"]

func opt_fullscreen_apply() -> void:
	OS.window_fullscreen = bool(GameData.settings["fullscreen"])

 
# Keep (all blood and bodies)
func opt_keep_toggle() -> void:
	GameData.settings["keep"] = !GameData.settings["keep"]
	opt_keep_apply()

func opt_keep_get() -> bool:
	return GameData.settings["keep"]

func opt_keep_apply() -> void:
	pass

# Last level
func opt_last_level_toggle() -> void:
	GameData.settings["last_level"] = !GameData.settings["last_level"]
	opt_last_level_apply()

func opt_last_level_get() -> bool:
	return GameData.settings["last_level"]

func opt_last_level_apply() -> void:
	pass

# Mute
func opt_mute_toggle() -> void:
	GameData.settings["mute"] = !GameData.settings["mute"]
	opt_mute_apply()

func opt_mute_get() -> bool:
	return GameData.settings["mute"]

func opt_mute_apply() -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_index, GameData.settings["mute"])

# Volume
func opt_volume_set(set) -> void:
	GameData.settings["volume"] = set
	opt_volume_apply()

func opt_volume_get() -> float:
	return GameData.settings["volume"]

func opt_volume_apply() -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, GameData.settings["volume"])
