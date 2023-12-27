extends Node

func _ready():
	var default_db = convert_percent_to_db(50)	
	AudioServer.set_bus_volume_db(0, default_db)
	for i in range(3):
		var db = convert_percent_to_db(GameManager.game_data.bus_idx_volume[i])
		AudioServer.set_bus_volume_db(i + 1, db)

func set_volume(bus_idx, volume):

	var i = bus_idx + 1

	if (volume == 0):
		AudioServer.set_bus_mute(i, true)
		return
		
	if AudioServer.is_bus_mute(i):
		AudioServer.set_bus_mute(i, false)
		
	var db = convert_percent_to_db(volume)	
	AudioServer.set_bus_volume_db(i, db)
	
	GameManager.game_data.bus_idx_volume[bus_idx] = volume
	GameManager.save_game_data()
		
func convert_percent_to_db(percent):
	var scale = 20
	var divisor = 50
	return scale * log(percent / divisor) / log(10)
