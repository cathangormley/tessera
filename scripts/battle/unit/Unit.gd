extends Node2D
class_name Unit

signal unit_moved(unit: Unit, old_cell: Cell, new_cell: Cell)
signal action_executed(unit: Unit, action: Action, target_area: CellArea)

signal unit_died(unit: Unit)

var battle: Battle
var grid_controller: GridController:
	get():
		return battle.grid_controller
var unit_controller: UnitController:
	get():
		return battle.unit_controller
var turn_controller: TurnController:
	get():
		return battle.turn_controller

@export var inventory: Inventory
@export var stats: Stats

var color: Color = Color(1, 1, 1)
var is_player_controlled = false

var cell: Cell:
	set(value):
		cell = value
		hovered_cell = value

## When the unit is selected, the unit temporarily hovers over a different cell
var hovered_cell: Cell:
	set(value):
		hovered_cell = value
		if hovered_cell != null: position = hovered_cell.position

var grid_pos: Vector2i:
	get():
		if cell == null:
			return Vector2i.MIN
		return cell.grid_pos

var reachable_cells: Array[Cell] = []
var paths_to_reachable_cells: Dictionary = {}

enum Faction { PLAYER, ENEMY }
var faction: Faction

var unit_name: String

var actions: Array[Action]:
	get():
		return item_actions + job_actions + race_actions + skill_actions + general_actions

var item_actions: Array[Action]:
	get: return inventory.actions

var job_actions: Array[Action] = []

var race_actions: Array[Action] = []

var skill_actions: Array[Action] = []

@export var general_action_templates: Array[ActionTemplate]
var general_actions: Array[Action]

## The amount of seconds to play the animation of the unit moving
const MOVE_TIME_SECONDS: float = 0.8

func new_unit(_unit_name: String) -> void:
	unit_name = _unit_name
	%AnimatedSprite2D.play()
	print("Unit " + unit_name + " was created")

 
func _draw() -> void:
	draw_circle(Vector2.ZERO, 8.0, color)
	print("Drew " + unit_name)


func remove_from_cell(old_cell: Cell) -> void:
	assert(cell == old_cell)
	assert(self == old_cell.unit)
	cell = null
	old_cell.unit = null


func add_to_cell(new_cell: Cell) -> void:
	assert(not new_cell.occupied, "Tried to move unit into occupied cell")
	cell = new_cell
	# Mark the grid cell as occupied and link the unit
	new_cell.unit = self


func move_to(new_cell: Cell) -> void:
	if cell == new_cell:
		return
	assert(not new_cell.occupied, "Tried to move unit into occupied cell")
	assert(new_cell in paths_to_reachable_cells.keys(), "Tried to move unit without path available")
	var old_cell = cell
	old_cell.unit = null
	new_cell.unit = self
	cell = new_cell
	
	var tween = create_tween()
	var path = paths_to_reachable_cells[new_cell] as Array[Cell]
	var path_start: Cell = path.pop_front()
	position = path_start.position
	for cell_in_path: Cell in path:
		tween.tween_property(self, "position", cell_in_path.position,
				MOVE_TIME_SECONDS / stats.movement)
	await tween.finished
	
	unit_moved.emit(self, old_cell, new_cell)


func hover_over_cell(new_cell: Cell) -> void:
	assert(new_cell in reachable_cells, "Tried to hover unit over non-reachable cell")
	hovered_cell = new_cell


## Returns a grid of distances and a grid of paths from unit
func get_distances_and_paths(start_cell: Cell, grid: Array, only_reachable_cells: bool = true) -> Dictionary:

	var start: Vector2i = start_cell.grid_pos
	var width: int = grid.size()
	var height: int = grid[0].size()
	
	# distances[x][y] stores cost to reach
	var distances: Array = []
	# paths[x][y]: Vector2i is previous cell's grid_pos in shortest path to grid[x][y]
	var paths: Array = []
	# costs[x][y] stores cost of cell at (x,y)
	# We do this once for speed
	var costs: Array = []

	for x in range(width):
		var dist_col: Array = []
		var path_col: Array = []
		var cost_col: Array = []
		for y in range(height):
			dist_col.append(INF)
			path_col.append(null) # null means no previous cell yet
			if stats.flying:
				cost_col.append((grid[x][y] as Cell).tile.flying_cost)
			else:
				cost_col.append((grid[x][y] as Cell).tile.walking_cost)
		distances.append(dist_col)
		paths.append(path_col)
		costs.append(cost_col)
	
	distances[start.x][start.y] = 0
	paths[start.x][start.y] = start  # start points to itself

	# Priority queue: array of [grid_pos, distance]
	var pq: Array = []
	pq.push_back([start, 0])
	
	while pq.size() > 0:
		var current = pq.pop_front()
		var current_grid_pos: Vector2i = current[0]
		var current_dist: int = current[1]
		
		# Skip if this is an outdated entry
		if current_dist > distances[current_grid_pos.x][current_grid_pos.y]:
			continue
		
		# Explore neighbors
		for dir: Vector2i in Utils.get_six_directions():
			var new_grid_pos: Vector2i = current_grid_pos + dir
			if new_grid_pos.x < 0 or new_grid_pos.x >= width:
				continue
			if new_grid_pos.y < 0 or new_grid_pos.y >= height:
				continue
			
			var new_cell: Cell = grid[new_grid_pos.x][new_grid_pos.y]
			if new_cell.occupied and new_cell.unit.faction != faction:
				continue

			var new_dist = current_dist + costs[new_grid_pos.x][new_grid_pos.y]
			if new_dist < distances[new_grid_pos.x][new_grid_pos.y] and new_dist <= stats.movement:
				distances[new_grid_pos.x][new_grid_pos.y] = new_dist
				paths[new_grid_pos.x][new_grid_pos.y] = current_grid_pos # record previous cell
				pq.push_back([new_grid_pos, new_dist])

	return {"distances": distances, "paths": paths}


## Helper function to reconstruct path to a target cell
func reconstruct_path(paths: Array, target_cell: Cell, grid: Array) -> Array[Cell]:
	var path: Array[Cell] = []
	var current = target_cell.grid_pos
	var prev: Vector2i
	while current != null:
		path.push_front(grid[current.x][current.y])
		prev = paths[current.x][current.y]
		if prev == current:
			break
		current = prev
	return path


func calculate_target_areas() -> void:
	for action in actions:
		print("Updating action target areas for: " + action.action_name)
		action.target.update_areas(hovered_cell, grid_controller)
	return


func update_reachable_cells_and_paths() -> void:
	var time0 = Time.get_ticks_msec()
	
	var distances_and_paths = get_distances_and_paths(cell, grid_controller.grid)

	var distances = distances_and_paths["distances"]
	var paths = distances_and_paths["paths"]

	var cells: Array[Cell] = []
	
	for i in distances.size():
		for j in distances[0].size():
			if distances[i][j] <= stats.movement:
				cells.append(grid_controller.grid[i][j])
	
	# Occupied cells are not reachable (except for the unit's cell, of course)
	cells = cells.filter(func(c: Cell): return not c.occupied or cell == c)
	
	reachable_cells = cells
	
	paths_to_reachable_cells = {}
	for reachable_cell in reachable_cells:
		paths_to_reachable_cells[reachable_cell] = reconstruct_path(paths, reachable_cell, grid_controller.grid)
	
	var time1 = Time.get_ticks_msec()
	print("Calculated reachable cells for: " + unit_name + ". " + str(time1 - time0) + " ms elapsed")


func get_target_areas(move: Cell, action: Action) -> Array[CellArea]:
	return action.target.get_areas(move, grid_controller)


func move_and_execute(move: Cell, action: Action, target_area: CellArea) -> void:
	await move_to(move)
	#item.execute(self, action, target_area)
	action.execute(self, target_area)
	action_executed.emit(self, action, target_area)


func is_friendly_unit(unit: Unit) -> bool:
	return faction == unit.faction


func is_enemy_unit(unit: Unit) -> bool:
	return faction != unit.faction


func take_damage(damage: int) -> void:
	stats.current_hp -= damage


func heal_damage(damage: int) -> void:
	stats.current_hp += damage


func die() -> void:
	print(unit_name + " dies")
	unit_died.emit(self)


@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var texture: Texture2D = sprite.sprite_frames.get_frame_texture("default", 0)


func get_unit_icon(unit: Unit) -> Texture2D:
	var sprite: AnimatedSprite2D = unit.get_node("AnimatedSprite2D")
	if sprite and sprite.sprite_frames:
		var frames = sprite.sprite_frames
		# Always use the first frame of the "Idle" animation
		if frames.has_animation("Idle"):
			return frames.get_frame_texture("Idle", 0)
	return null


func initialize(_base_stats: AttributeArray, _race: Race, _job: Job, _job_level: int) -> void:
	stats.generate_stats(_base_stats, _race, _job, _job_level)
	inventory.create_armor_slots(_race)
	
	# Initialize actions
	for action_template in stats.race.action_templates:
		race_actions.append(action_template.to_action())
	for action_template in general_action_templates:
		general_actions.append(action_template.to_action())

func add_item_to_inventory(item: Item) -> void:
	inventory.add_item(item)


func get_skills() -> Array[Skill]:
	return stats.skills
