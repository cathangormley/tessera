## Represents a group of cells in the grid
extends Resource
class_name CellArea

## The cells contained in the cell area
var cells: Array[Cell]


func _init(_cells: Array[Cell]) -> void:
	cells = _cells


## Returns an array of units within the CellArea
func get_units() -> Array[Unit]:
	var units: Array[Unit]
	for cell in cells:
		if cell.occupied: units.append(cell.unit)
	return units
