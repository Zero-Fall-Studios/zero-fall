extends Resource
class_name GameData

@export var game_name : String = ""
@export var bus_idx_volume = [50, 50, 50]
@export var use_mouse : bool = false

func debug():
	print("Game Name: ", game_name)
	print("Bus Index: ", bus_idx_volume)
	print("Use Mouse: ", use_mouse)
