extends Bot
class_name BotState

var states = {
	"idle": ["watch_player"],
	"chase": ""
}

func _ready():
	add_to_group("Enemy")

func watch_player():
	if get_player():
		if get_player_visibility():
			if get_player_distance() < view_range:
				return true
