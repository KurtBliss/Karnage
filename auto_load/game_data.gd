"""Autoload/game_data.gd"""
extends Node

const FILE_NAME = "user://game-data.json"

var settings_defaults = {
	"fullscreen": false,
	"keep": true
}

var settings = settings_defaults

func save():
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(settings))
	file.close()

func load():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			if data.size() == settings.size():
				settings = data
			else:
				print("cant load data, may be an older version")
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")
