extends Node

var save_file_path = "user://save/"
var save_file_name = "GameData.tres"
var save_file = save_file_path + save_file_name

var game_data : GameData = GameData.new()

func _ready():
	# clear_game_data()
	verify_save_dir(save_file_path)
	if not FileAccess.file_exists(save_file):
		save_game_data()
	load_game_data()

func verify_save_dir(path):
	DirAccess.make_dir_absolute(path)
	
func save_game_data():
	# game_data.debug()
	ResourceSaver.save(game_data, save_file)

func load_game_data():
	var r = ResourceLoader.load(save_file)
	if r != null:
		game_data = r.duplicate(true)
		# game_data.debug()
	else:
		print("No save file found")

func clear_game_data():
	game_data = GameData.new()
	save_game_data()
	
