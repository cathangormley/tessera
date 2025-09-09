## A cone of with specified range and width of 60 degrees
extends Target
class_name TargetCone

@export var cone_range: int

## Get a list of areas: one area for each cone extending from origin
func get_areas(origin: Cell, grid_controller: GridController) -> Array[CellArea]:
	
	var cones: Array[CellArea] = []
	var dirs := Utils.get_six_directions()
	
	for i in range(dirs.size()):
		
		var j := int(fmod(i + 1, 6))
		var dir1 := dirs[i]
		var dir2 := dirs[j]
		var cone: Array[Vector2i] = []
		
		for n in range(1, cone_range + 1):
			for k in range(n + 1):
				cone.append(origin.grid_pos + k * dir1 + (n - k) * dir2)
		
		cones.append(grid_controller.grid_pos_to_cell_area(cone))
	
	return cones
