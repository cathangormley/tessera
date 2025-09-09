## Represents the possible target areas of an action
extends Resource
class_name Target

## When a unit takes an action there are different possible areas
## that the unit can target depending on the type of action taken
## E.g. Basic attack has range one, lightning spell hits all targets in a line etc.

## A list of targetable areas 
var areas: Array[CellArea]

## The area currently selected
var selected_area: CellArea


func update_areas(origin: Cell, grid_controller) -> void:
	areas = get_areas(origin, grid_controller)
	selected_area = areas[0]
	print("count of areas: ", areas.size())
	print("count of selected_area.cells: ", selected_area.cells.size())
	

## Returns all the possible target areas for this target type
func get_areas(_origin: Cell, _grid_controller) -> Array[CellArea]:
	assert(false, "This method must be overridden")
	return []


## For any Target type we want to be able to update the selected area (or not!)
## Depends on what cell we are hovering over / selecting
func update_selected_area(cell: Cell) -> void:
	print("Updating selected area")
	for cell_area: CellArea in areas:
		if cell in cell_area.cells:
			selected_area = cell_area
			return
