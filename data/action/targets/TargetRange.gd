## Target with possible target areas being any (one) cell
## with specified distance away from origin
extends Target
class_name TargetRange

@export var min_range: int
@export var max_range: int


## Get a list of areas: every cell in range to its own CellArea
func get_areas(origin: Cell, grid_controller: GridController) -> Array[CellArea]:
	var cell_areas: Array[CellArea]

	for cell in grid_controller.cells:
		var dist = origin.get_raw_distance_to(cell)
		if min_range <= dist and dist <= max_range:
			cell_areas.append(CellArea.new([cell]))
	
	return cell_areas
