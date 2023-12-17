extends Node

var save_file_path = "user://save/"
var save_file_name = "GameData.tres"

var game_data : GameData = GameData.new()


func _ready():
	pass
	# verify_save_dir(save_file_path)
	# if not FileAccess.file_exists(save_file_path + save_file_name):
	# 	save_game_data()
	# load_game_data()

func verify_save_dir(path):
	DirAccess.make_dir_absolute(path)
	
func save_game_data():
#	game_data.debug()
	ResourceSaver.save(game_data, save_file_path + save_file_name)

func load_game_data():
	game_data = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
#	game_data.debug()
