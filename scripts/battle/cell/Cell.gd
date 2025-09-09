extends Node2D
class_name Cell

## Position on grid
var grid_pos: Vector2i
var tile: Tile
var unit: Unit = null
var occupied: bool:
	get():
		return unit != null

## Apothem: The radius of an inscribed circle of a hexagon
static var APO: float = 32.0

var hex_points: Array[Vector2]

func _init(_grid_pos: Vector2i, _position: Vector2, _apo: float, _tile: Tile):
	grid_pos = _grid_pos
	position = _position
	tile = _tile
	APO = _apo
	hex_points = Utils.get_hex_points(Vector2.ZERO, APO)


func _draw() -> void:
	draw_colored_polygon(hex_points, tile.color)


func highlight(color: Color) -> void:
	draw_colored_polygon(hex_points, color)


## Return the raw distance from this cell to another cell.
## Raw distance two cells is defined as the number of cells between them (inclusive of end cell)
func get_raw_distance_to(cell: Cell) -> int:
	var diff: Vector2i = cell.grid_pos - grid_pos
	if diff.sign() == Vector2i(1, 1) or diff.sign() == Vector2i(-1, -1):
		return max(abs(diff.x), abs(diff.y))
	else:
		return abs(diff.x) + abs(diff.y)
