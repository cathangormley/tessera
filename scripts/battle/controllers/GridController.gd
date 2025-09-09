extends Node2D
class_name GridController

signal cell_hovered(cell: Cell)
signal cell_left_clicked(cell: Cell)
signal cell_right_clicked(cell: Cell)

@onready var state_controller: StateController = get_node("/root/Battle/StateController")
@onready var cell_container = $CellContainer
@onready var highlight_layer: HighlightLayer = %HighlightLayer
@onready var camera: CameraGrid = %Camera

@export var grid_width: int = 20
@export var grid_height: int = 20

# Spacing of grid
@export var cell_size: int = Cell.APO
# For no gap: cell_size / sqrt(3) ~ 0.577 * cell_size
@export var cell_draw_radius = 0.55 * cell_size
@export var highlight_cell_draw_radius = 0.51 * cell_size


var grid: Array = []
var cells: Array[Cell]:
	get():
		var c: Array[Cell] = []
		for i in range(grid.size()):
			c.append_array(grid[i])
		return c


## The cell that the mouse is hovering over
var mouse_cell: Cell
## This should only be changed by parent
var highlighted_unit: Unit = null
## This should only be changed by parent
var selected_action: Action = null

func _ready():
	create_grid()
	camera.map_bounds = Rect2(Vector2.ZERO, cell_size * Vector2(grid_width, grid_height))


func create_grid():
	grid.resize(grid_width)
	
	var tile_weights: Dictionary[Tile, float] = {
		TileDB.tiles["grass"]: 60.0,
		TileDB.tiles["water"]: 10.0,
		TileDB.tiles["hill"]: 10.0,
		TileDB.tiles["mountain"]: 20.0,
	}
	
	print(TileDB.tiles["grass"].name)
	
	for x in range(grid_width):
		grid[x] = []
		for y in range(grid_height):
			var grid_pos = Vector2i(x, y)
			var the_tile: Tile = Utils.choose_weighted(tile_weights)
			var cell = Cell.new(
					grid_pos,
					grid_pos_to_position(grid_pos),
					int(cell_size / 2),
					the_tile
			)
			grid[x].append(cell)
			cell_container.add_child(cell)
	
	mouse_cell = grid[0][0]


## Converts grid coordinates to Node2D position
func grid_pos_to_position(grid_pos: Vector2i) -> Vector2:
	return cell_size * Vector2((grid_pos.x - 0.5 * grid_pos.y), sqrt(3)/2.0 * grid_pos.y)
	#return Vector2(32 * grid_pos.x - 16 * grid_pos.y, 28 * grid_pos.y)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left_click"):
		cell_left_clicked.emit(mouse_cell)
	if event.is_action_pressed("ui_right_click"):
		cell_right_clicked.emit(mouse_cell)

	if event is InputEventMouseMotion:
		var new_mouse_cell = cell_at_mouse_pos()
		if new_mouse_cell != mouse_cell and new_mouse_cell != null:
			mouse_cell = new_mouse_cell
			cell_hovered.emit(mouse_cell)


## Returns the cell where the mouse currently is
func cell_at_mouse_pos():
	var mouse_pos = get_global_mouse_position()
	return position_to_cell(mouse_pos)


## Calculate cell at given position
func position_to_cell(pos: Vector2) -> Cell:
	var grid_pos := position_to_grid_pos(pos)
	return grid_pos_to_cell(grid_pos)


## Calculate the grid_pos matching given position
func position_to_grid_pos(pos: Vector2) -> Vector2i:
	# TODO! Get rid of this and replace with collision shape + signal for each cell
	# Actually not sure if it would be worth it, potential performance problems
	# from having thousands of area2Ds
	
	# Divide the grid into rectangles
	# The rectangles have two corners in the centre of two diagonally adjacent hexes
	# and two corners on the sides of hexes
	var rect_size: Vector2 = Vector2(cell_size / 2.0, sqrt(3) * cell_size / 2.0)
	var rect_pos: Vector2 = pos / rect_size
	var rect_pos_m: Vector2i = Vector2i(floor(rect_pos)) # Whole part
	var rect_pos_r: Vector2 = rect_pos - floor(rect_pos) # Fractional part
	
	var s: int = (rect_pos_m.x + rect_pos_m.y) % 2
	var d: Vector2i
	if s == 0:
		# Two cases: either top-left and bottom-right are hex centres...
		d = Vector2i(1,1) if 3 * rect_pos_r.y + rect_pos_r.x >= 2 else Vector2i(0,0)
	else:
		# ...or top-right and bottom-left are hex centres
		d = Vector2i(0,1) if 3 * rect_pos_r.y - rect_pos_r.x >= 1 else Vector2i(1,0)

	# The correct hex in rect coordinates
	var rec_hex: Vector2i = rect_pos_m + d
	
	return Vector2i((rec_hex.x + rec_hex.y) / 2, rec_hex.y)


## Return the cell in the grid at the given grid_pos
func grid_pos_to_cell(grid_pos: Vector2i) -> Cell:
	if 0 <= grid_pos.x and grid_pos.x < grid_width:
		if 0 <= grid_pos.y and grid_pos.y < grid_height:
			return grid[grid_pos.x][grid_pos.y]
	return null


## Returns a cell area from the given array of grid positions
func grid_pos_to_cell_area(grid_positions: Array[Vector2i]) -> CellArea:
	var cells: Array[Cell]
	for grid_pos in grid_positions:
		var cell := grid_pos_to_cell(grid_pos)
		if cell != null:
			cells.append(cell)
	return CellArea.new(cells)


func highlight_action(action: Action) -> void:
	highlight_layer.highlight_action(action)


func highlight_action_area(action: Action) -> void:
	highlight_layer.highlight_action_area(action)


func highlight_unit_movement(unit: Unit) -> void:
	highlight_layer.highlight_unit_movement(unit)
