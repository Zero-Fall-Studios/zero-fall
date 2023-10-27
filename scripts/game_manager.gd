extends Node

var save_file_path = "user://save/"
var save_file_name = "GameData.tres"

var game_data : GameData = GameData.new()

var available_scenes = {}
var current_scene = []

func _ready():
	verify_save_dir(save_file_path)
	if not FileAccess.file_exists(save_file_path + save_file_name):
		save_game_data()
	load_game_data()

func verify_save_dir(path):
	DirAccess.make_dir_absolute(path)
	
func save_game_data():
#	game_data.debug()
	ResourceSaver.save(game_data, save_file_path + save_file_name)

func load_game_data():
	game_data = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
#	game_data.debug()

func add_scene(name, scene):
	available_scenes[name] = scene

func append_scene(scene_name):
	var scene = available_scenes[scene_name]
	var top_scene = current_scene.back()
	if top_scene:
		await top_scene.fade_out() 
	current_scene.append(scene)
#	scene.show()	
	
func pop_scene():
	var scene = current_scene.pop_back()
	await scene.hide()
	var top_scene = current_scene.back()
	if top_scene:
		top_scene.show()
