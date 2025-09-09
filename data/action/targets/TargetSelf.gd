extends Target
class_name TargetSelf


## Returns a single area with a CellArea of origin only
func get_areas(origin: Cell, _grid_controller: GridController) -> Array[CellArea]:
	return [CellArea.new([origin])]
