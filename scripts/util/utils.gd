extends Node2D

## Choose a key of the given dictionary with probability
## proportional to the values of the dictionary
func choose_weighted(dict: Dictionary):
	
	var keys: Array = []
	var values := PackedFloat32Array()
	
	for key in dict.keys():
		var w: float = dict[key]
		if w > 0.0:
			keys.append(key)
			values.append(w)
	
	if values.size() == 0:
		return null
	
	var rng = RandomNumberGenerator.new()
	return keys[rng.rand_weighted(values)]

## Returns the six directions of a hexagonal grid
## In order, starting with HEX_RIGHT and going clockwise 
func get_six_directions() -> Array[Vector2i]:
	return [Vector2i(1,0),		# Right
			Vector2i(1, 1),		# Down-right
			Vector2i(0,1),		# Down-left
			Vector2i(-1,0),		# Left
			Vector2i(-1, -1),	# Up-left
			Vector2i(0,-1)]		# Up-right


func get_hex_points(center: Vector2, radius:float) -> Array[Vector2]:
	# Scale radius by 2 / sqrt(3) for no gap
	var points: Array[Vector2] = []
	for i in range(6):
		var angle = deg_to_rad(30 + 60 * i)  # 30° offset for pointy top hexes
		points.append(center + Vector2(cos(angle), sin(angle)) * radius)
	return points


## Roll (for hit etc.) with given percent chance of success
func roll_percentage(success_chance: int) -> bool:
	var roll = randi_range(0, 99)
	return roll < success_chance
