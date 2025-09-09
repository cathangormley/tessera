extends Target
class_name TargetLine

@export var line_range: int

## Get a list of areas: one area for each line extending from origin
func get_areas(origin: Cell, grid_controller: GridController) -> Array[CellArea]:
	var lines: Array[CellArea] = []
	for dir in Utils.get_six_directions():
		var line: Array[Vector2i] = []
		for n in range(1, line_range + 1):
			line.append(origin.grid_pos + dir * n)
		lines.append(grid_controller.grid_pos_to_cell_area(line))

	return lines

# TODO! for dir in 6 six directions, shoot out from origin until range reached OR hit a cell with cell.tile_type.blocks == true
