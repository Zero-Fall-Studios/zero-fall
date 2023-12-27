extends Resource
class_name GameData

@export var game_name : String = ""
@export var bus_idx_volume = [50, 50, 50]

func debug():
	print("Game Name: ", game_name)
	print("Bus Index: ", bus_idx_volume)
