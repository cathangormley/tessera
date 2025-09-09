## This node's only job is to draw highlighted cells
extends Node2D
class_name HighlightLayer

enum HighlightType { MOVEMENT, ACTION }

class HighlightData:
	var cells: Array[Cell]
	var color: Color

	func _init(_cells: Array[Cell] = [], _color: Color = Color.WHITE) -> void:
		cells = _cells
		color = _color

var highlights: Dictionary[HighlightType, HighlightData] = {}

func _draw() -> void:
	for type in highlights:
		var data: HighlightData = highlights[type]
		print("Drawing highlights: " + str(data.cells.size()) + " cells")
		for cell in data.cells:
			# Have to convert cell.hex_points (which are relative to cell.position) into global coordinates
			var hex_points: Array[Vector2]
			for point in cell.hex_points:
				hex_points.append(point + cell.position)
			draw_colored_polygon(hex_points, data.color)


func highlight_action(action: Action) -> void:
	if action == null:
		_clear_highlight(HighlightType.ACTION)
		return
	
	var cells: Array[Cell] = []
	for cell_area in action.target.areas:
		cells.append_array(cell_area.cells)
	_set_highlight(
		HighlightType.ACTION,
		cells,
		action.highlight_color
	)


func highlight_action_area(action: Action) -> void:
	if action == null:
		_clear_highlight(HighlightType.ACTION)
		return

	_set_highlight(
		HighlightType.ACTION,
		action.target.selected_area.cells,
		action.highlight_color
	)


func highlight_unit_movement(unit: Unit) -> void:
	if unit == null:
		_clear_highlight(HighlightType.MOVEMENT)
		return

	_set_highlight(
		HighlightType.MOVEMENT,
		unit.reachable_cells,
		Color(0, 0, 1, 0.5)
	)


# Set highlights for a specific type (overwrites that type’s cells)
func _set_highlight(type: HighlightType, cells: Array[Cell], color: Color) -> void:
	highlights[type] = HighlightData.new(cells, color)
	queue_redraw()


# Clear a specific type
func _clear_highlight(type: HighlightType) -> void:
	if type in highlights:
		highlights.erase(type)
		queue_redraw()
