## Represents the AI behind a computer controlled unit
extends Resource
class_name AI

# Reference to the unit this mind controls
var unit: Unit

class CourseOfAction:
	var move: Cell
	var action: Action
	var target_area: CellArea
	
	func _init(_move: Cell, _action: Action, _target_area: CellArea) -> void:
		move = _move
		action = _action
		target_area = _target_area


func _init(_unit: Unit) -> void:
	unit = _unit


func get_all_courses_of_action() -> Array[CourseOfAction]:
	var coas: Array[CourseOfAction] = []
	for move in unit.reachable_cells:
		for action in unit.actions:
			if not action.can_execute(unit):
				continue
			for target_area in unit.get_target_areas(move, action):
				coas.append(CourseOfAction.new(move, action, target_area))
	return coas


func get_enemy_units(grid: Array) -> Array[Unit]:
	var units: Array[Unit]
	for i in range(grid.size()):
		for j in range(grid[0].size()):
			var cell: Cell = grid[i][j]
			if cell.unit != null:
				units.append(cell.unit)

	return units.filter(func(u: Unit): return unit.is_enemy_unit(u))


func get_closest_enemy_unit_by_raw_distance(grid: Array) -> Unit:
	var enemy_units = get_enemy_units(grid)
	
	var closest_enemy_unit: Unit
	var closest_raw_distance: int = 1_000_000
	
	for enemy_unit in enemy_units:
		var raw_distance: int = unit.cell.get_raw_distance_to(enemy_unit.cell)
		if raw_distance < closest_raw_distance:
			closest_raw_distance = raw_distance
			closest_enemy_unit = enemy_unit
	
	return closest_enemy_unit


func choose_course_of_action(_grid: Array) -> CourseOfAction:
	assert(false, "This method must be overridden")
	return null
