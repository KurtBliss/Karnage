"""Autoload/game_data.gd"""
extends Node
const FILE_GAME_SETTINGS = "user://game-data-settings.json"
const FILE_GAME_DATA = "user://game-data.json"
var settings_defaults = {
	"settings-ver": 0,
	"fullscreen": false,
	"keep": true
}
var game_data_defaults = {
	"game-data-ver": 0,
	"levels": {
		"Corridor": get_default_level_data(),
		"City": get_default_level_data()
	}
}
var settings = settings_defaults
var game_data = game_data_defaults

###################-FUNCS-####################

func get_default_level_data():
	return {
		"highscore": 0
	}

func get_level_data(level):
	return game_data["levels"][level]

func get_level_highscore(level):
	var ld = get_level_data(level)
	var hs = ld["highscore"]
	
	return hs

func set_level_data(level, set):
	game_data["levels"][level] = set

func set_level_highscore(level, set):
	game_data["levels"][level]["highscore"] = set

###################-FILE MNG-####################

func save():
	save_file(FILE_GAME_SETTINGS, settings)
	save_file(FILE_GAME_DATA, game_data)

func load_data():
	var settings_ld = load_file(FILE_GAME_SETTINGS, settings_defaults)
	var game_data_ld = load_file(FILE_GAME_DATA, game_data_defaults)
	if settings_ld:
		if settings_ld.has("settings-ver"):
			if settings_ld["settings-ver"] == settings["settings-ver"]:
				settings = settings_ld
	if game_data_ld:
		if game_data_ld.has("game-data-ver"):
			if game_data_ld["game-data-ver"] == game_data["game-data-ver"]:
				game_data = game_data_ld

func save_file(fn, data):
	var file = File.new()
	file.open(fn, File.WRITE)
	file.store_string(to_json(data))
	file.close()

func load_file(fn, deffault_data):
	var file = File.new()
	if file.file_exists(fn):
		file.open(fn, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			if data.size() == deffault_data.size():
				return data
			else:
				print("cant load data, may be an older version")
				return false
		else:
			printerr("Corrupted data!")
			return false
	else:
		printerr("No saved data!")
		return false

