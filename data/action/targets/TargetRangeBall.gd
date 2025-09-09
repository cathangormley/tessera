## Target with possible target areas being 'balls' of 7 cells with center cell
## a specified distance away from origin
extends Target
class_name TargetRangeBall

@export var min_range: int
@export var max_range: int


## Get a list of areas: every cell in range to its own CellArea
func get_areas(origin: Cell, grid_controller: GridController) -> Array[CellArea]:
	
	var center_cells: Array[Cell]
	
	for cell in grid_controller.cells:
		var dist = origin.get_raw_distance_to(cell)
		if min_range <= dist and dist <= max_range:
			center_cells.append(cell)
	
	var cell_areas: Array[CellArea]
	
	for cell in center_cells:
		var d: Array[Vector2i] = [cell.grid_pos]
		for dir in Utils.get_six_directions():
			d.append(cell.grid_pos + dir)
		cell_areas.append(grid_controller.grid_pos_to_cell_area(d))
	
	return cell_areas


func update_selected_area(cell: Cell) -> void:
	print("Updating selected area")
	for cell_area: CellArea in areas:
		if cell == cell_area.cells[0]:
			selected_area = cell_area
			return
