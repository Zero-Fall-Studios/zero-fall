extends TileMap

@export var terrain_set_index : int = 0

@export var width = 64
@export var height = 16
@export var temperature_threshold : float = 0
@export var moisture_threshold : float = 0
@export var altitude_threshold : float = 0
var temperature = FastNoiseLite.new()
var moisture = FastNoiseLite.new()
var altitude = FastNoiseLite.new()

func _ready():
	temperature.seed = randi();
	moisture.seed = randi();
	altitude.seed = randi();
	altitude.frequency = 0.05
	generate_chunk()
	
func generate_chunk():
	var path = []
	var tile_position = local_to_map(position)
	var center_x = tile_position.x - width / 2
	var center_y = tile_position.y - height / 2
	for x in width:
		var x_offset = center_x + x
		for y in height:
			var y_offset = center_y + y
			var moist = moisture.get_noise_2d(x_offset, y_offset)
			var temp = temperature.get_noise_2d(x_offset, y_offset)
			var alt = altitude.get_noise_2d(x_offset, y_offset)
		
			if alt < altitude_threshold:
				path.append(Vector2i(x, y))
			
#			# Ocean
#			if alt < 0.2:
#				#tilemap.set_cells_terrain_connect(0, pos, 0, terrain_set_index)
#				pass
#
#			# Beach	
#			elif between(alt, 0.2, 0.25):
#				#tilemap.set_cells_terrain_connect(0, pos, 0, terrain_set_index)
#				pass
#
#			# Other Bioms
#			elif alt > 0.25:
#
#				# Snow
#				if between(moist, 0, 0.9) and temp < 0.1:
#					pass
#
#				# Tiaga
#				if between(moist, 0, 0.9) and between(temp, 0.1, 0.2):
#					pass
#
#				# Plains
#				if between(moist, 0, 0.9) and between(temp, 0.2, 0.3):
#					pass
#
#				# Mushroom
#				if between(moist, 0, 0.4) and between(temp, 0.4, 0.5):
#					pass
#
#				# Desert
#				if between(moist, 0, 0.4) and between(temp, 0.5, 1):
#					pass
#
#				# Jungle
#				if between(moist, 0.4, 1) and between(temp, 0.4, 1):
#					pass
#
#				# Water
#				if between(moist, 0.9, 1) and between(temp, 0, 1):
#					pass
	
	set_cells_terrain_connect(0, path, 0, terrain_set_index)
				
func between(val, start, end):
	return start <= val and val < end
