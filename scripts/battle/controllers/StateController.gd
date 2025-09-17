## This handles the state of a battle
## E.g. The player has selected a unit, it is now in "Unit Selected Mode"
# TODO! Look up how to better refactor finite state machines
extends Node
class_name StateController

@onready var grid_controller: GridController = %GridController

signal state_changed(new_state: State)

signal unit_highlighted(unit: Unit)

signal action_area_highlighted(action: Action)

signal unit_hovered_over_cell(unit: Unit, cell: Cell)

enum State {
	SELECT_UNIT,		## Unselected
	MOVE_UNIT,			## Choosing where to move
	SELECT_ACTION,		## Choosing what action to take
	SELECT_ACTION_AREA,	## Choosing where to aim action
	AI,					## AI acting
	NA,					## Null state for going between turns
}

const STATE_NAMES: Dictionary[State, String] = {
	State.SELECT_UNIT: "SELECT_UNIT",
	State.MOVE_UNIT: "MOVE_UNIT",
	State.SELECT_ACTION: "SELECT_ACTION",
	State.SELECT_ACTION_AREA: "SELECT_ACTION_AREA",
	State.AI: "AI",
	State.NA: "NA",
}

var state: State = State.NA
var selected_action: Action = null

var turn_unit: Unit = null

func _ready() -> void:
	pass


func change_state(new_state: State):
	if state == new_state:
		return
	var old_state = state
	state = new_state
	state_changed.emit(old_state, state)


func cell_hovered(cell: Cell):
	match state:
		State.SELECT_UNIT:
			unit_highlighted.emit(cell.unit)
		State.MOVE_UNIT:
			if cell in turn_unit.reachable_cells:
				unit_hovered_over_cell.emit(turn_unit, cell)
		State.SELECT_ACTION_AREA:
			selected_action.target.update_selected_area(cell)
			action_area_highlighted.emit(selected_action)
		_:
			pass


func cell_left_clicked(cell: Cell) -> void:
	match state:
		State.SELECT_UNIT:
			if cell.unit == turn_unit:
				change_state(State.MOVE_UNIT)
		State.MOVE_UNIT:
			if cell in turn_unit.reachable_cells:
				change_state(State.SELECT_ACTION)
		State.SELECT_ACTION_AREA:
			if cell in selected_action.target.selected_area.cells:
				turn_unit.move_and_execute(turn_unit.hovered_cell,
						selected_action, selected_action.target.selected_area)
		_:
			pass


func cell_right_clicked(cell: Cell) -> void:
	match state:
		State.SELECT_UNIT:
			# If unit then display info
			pass
		State.MOVE_UNIT:
			change_state(State.SELECT_UNIT)
		State.SELECT_ACTION:
			change_state(State.MOVE_UNIT)
		State.SELECT_ACTION_AREA:
			change_state(State.SELECT_ACTION)


func action_button_pressed(action: Action) -> void:
	if state == State.SELECT_ACTION and action.can_execute(turn_unit):
		selected_action = action
		change_state(State.SELECT_ACTION_AREA)


func start_turn(unit: Unit) -> void:
	turn_unit = unit
	if turn_unit.is_player_controlled:
		change_state(State.SELECT_UNIT)
	else:
		change_state(State.AI)


func end_turn(_unit: Unit) -> void:
	change_state(State.NA)


## Reset turn_unit's hovered_cell to its actual cell 
func unhover() -> void:
	turn_unit.hovered_cell = turn_unit.cell
