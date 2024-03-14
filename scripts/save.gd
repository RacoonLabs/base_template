extends Node

const SAVE_KEYS = {
	"LEVEL": "level",
	"CURRENT_LEVEL": "current_level",
	"HINTS": "hints",
	"REWARD_REDEEMED_DATE": "reward_redeemed_date",
	"PRIZE_STEP": "prize_step",
	"PRIZE_LEVEL": "prize_level"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
		
func save_data(force_reset: bool = false):
	var save_dict = {
		SAVE_KEYS.LEVEL : GameManager.levels_completed if not force_reset else 0,
		SAVE_KEYS.CURRENT_LEVEL : GameManager.current_level_by_difficult if not force_reset else 1,
		SAVE_KEYS.PRIZE_STEP : GameManager.actual_prize_step if not force_reset else 0,
		SAVE_KEYS.PRIZE_LEVEL : GameManager.actual_prize_level if not force_reset else 0,
		SAVE_KEYS.HINTS : Hint.get_hint_quantity() if not force_reset else 3,
		SAVE_KEYS.REWARD_REDEEMED_DATE : Hint.get_reward_redeemed_date() if not force_reset else null
	}
	return save_dict

func save_game_data(force_reset: bool = false):
	var save_game_data = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	# Call save function.
	var data = save_data(force_reset)
	# Serialized to JSON string.
	var json_string = JSON.stringify(data)
	# Store the save dictionary as a new line in the save file.
	save_game_data.store_line(json_string)

func load_game_data():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
		
	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		# Creates the helper class to interact with JSON
		var json = JSON.new()
		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		# Get the data from the JSON object
		var data = json.get_data()
		GameManager.levels_completed = int(data[SAVE_KEYS.LEVEL]) if data.has(SAVE_KEYS.LEVEL) else 0;
		GameManager.current_level_by_difficult = int(data[SAVE_KEYS.CURRENT_LEVEL]) if data.has(SAVE_KEYS.CURRENT_LEVEL) else 1;
		GameManager.actual_prize_level = int(data[SAVE_KEYS.PRIZE_LEVEL]) if data.has(SAVE_KEYS.PRIZE_LEVEL) else 0;
		GameManager.actual_prize_step = int(data[SAVE_KEYS.PRIZE_STEP]) if data.has(SAVE_KEYS.PRIZE_STEP) else 0;
		Hint.set_hint_quantity(data[SAVE_KEYS.HINTS] if data.has(SAVE_KEYS.HINTS) else 3)
		Hint.set_reward_redeemed_date(data[SAVE_KEYS.REWARD_REDEEMED_DATE] if data.has(SAVE_KEYS.REWARD_REDEEMED_DATE) else null);

func save_config(language: String):
	var config_data = FileAccess.open("user://config.save", FileAccess.WRITE)
	var json_string = JSON.stringify({
		"language": language
	})
	config_data.store_line(json_string)
