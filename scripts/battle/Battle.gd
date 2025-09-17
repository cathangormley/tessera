extends Node2D
class_name Battle

# References to child controllers
@onready var grid_controller: GridController = %GridController
@onready var unit_controller: UnitController = %UnitController
@onready var state_controller: StateController = %StateController
@onready var turn_controller: TurnController = %TurnController

@onready var unit_hud := %UnitHUD
@onready var turn_queue_hud := %TurnQueueHUD
@onready var action_menu_hud := %ActionMenuHUD

var highlighted_unit: Unit
var selected_unit: Unit

var selected_action: Action

## Temp to quickly avoid accidental double clicks
var temp_right_click_timer_msec: int = 0

func _ready():
	
	grid_controller.create_grid()
	unit_controller.create_units()
	
	turn_controller.start_turn()
	
	print("Main scene initialized.")


func _on_grid_controller_cell_hovered(cell: Cell) -> void:
	print("Cell was hovered: " + str(cell.grid_pos))
	state_controller.cell_hovered(cell)


func _on_grid_controller_cell_left_clicked(cell: Cell) -> void:
	print("Cell was left clicked: " + str(cell.grid_pos))
	state_controller.cell_left_clicked(cell)


func _on_grid_controller_cell_right_clicked(cell: Cell) -> void:
	if Time.get_ticks_msec() - temp_right_click_timer_msec < 200:
		return
	temp_right_click_timer_msec = Time.get_ticks_msec()
	print("Cell was right clicked: " + str(cell.grid_pos))
	state_controller.cell_right_clicked(cell)


func _on_unit_controller_unit_removed(unit: Unit, _old_cell: Cell) -> void:
	print("Unit was removed: " + unit.unit_name)
	unit_controller.calculate_reachable_cells()
	turn_controller.remove_unit(unit)


func _on_unit_controller_unit_added(unit: Unit, _new_cell: Cell) -> void:
	print("Unit was added: " + unit.unit_name)
	unit_controller.calculate_reachable_cells()
	turn_controller.add_unit(unit)


func _on_unit_moved(unit: Unit, _old_cell: Cell, _new_cell: Cell) -> void:
	print("Unit was moved: " + unit.unit_name)
	unit_controller.calculate_reachable_cells()


func _on_action_executed(unit: Unit, action: Action, _target_area: CellArea) -> void:
	print("Action was executed by " + unit.unit_name + ": " + action.action_name)
	turn_controller.end_turn()


func _on_state_controller_unit_highlighted(unit: Unit) -> void:
	if unit != null: print("Unit was highlighted: " + unit.unit_name)
	grid_controller.highlight_unit_movement(unit)
	unit_hud.highlight_unit_hud(unit)


func _on_state_controller_state_changed(old_state: StateController.State, new_state: StateController.State) -> void:
	print("State was changed from: " + state_controller.STATE_NAMES[old_state]
			+ " to " + state_controller.STATE_NAMES[new_state])
	match old_state:
		StateController.State.SELECT_UNIT:
			pass
		StateController.State.MOVE_UNIT:
			pass
		StateController.State.SELECT_ACTION:
			action_menu_hud.free_menu(state_controller.turn_unit)
		StateController.State.SELECT_ACTION_AREA:
			grid_controller.highlight_action(null)

	match new_state:
		StateController.State.SELECT_UNIT:
			state_controller.unhover()
			grid_controller.highlight_unit_movement(null)
			unit_hud.highlight_unit_hud(null)
		StateController.State.MOVE_UNIT:
			grid_controller.highlight_unit_movement(state_controller.turn_unit)
		StateController.State.SELECT_ACTION:
			grid_controller.highlight_unit_movement(null)
			state_controller.turn_unit.calculate_target_areas()
			action_menu_hud.open_action_menu(state_controller.turn_unit)
		StateController.State.SELECT_ACTION_AREA:
			grid_controller.highlight_action_area(state_controller.selected_action)
		StateController.State.AI:
			(turn_controller.turn_unit as AIUnit).take_turn(grid_controller.grid)


func _on_state_controller_action_area_highlighted(action: Action) -> void:
	print("Action area was highlighted: " + str(action.target.selected_area.cells))
	grid_controller.highlight_action_area(state_controller.selected_action)


func _on_turn_controller_turn_started(unit: Unit, time: float) -> void:
	print("Turn started for: " + unit.unit_name + ", time: " + str(time))
	turn_queue_hud.update_queue_display()
	state_controller.start_turn(unit)


func _on_turn_controller_turn_ended(unit: Unit, time: float) -> void:
	print("Turn ended for: " + unit.unit_name + ", time: " + str(time))
	state_controller.end_turn(unit)
	turn_controller.start_turn()


func _on_turn_queue_hud_unit_clicked(unit: Unit) -> void:
	print("Clicked on unit in turn queue: " + unit.unit_name)
	grid_controller.camera.focus_on_cell(unit.cell)


func _on_action_menu_hud_menu_exited() -> void:
	print("Action menu exited")
	state_controller.change_state(StateController.State.MOVE_UNIT)


func _on_action_menu_hud_action_hovered(action: Action) -> void:
	if action != null: print("Action button was hovered: ", action.action_name)
	if state_controller.state == state_controller.State.SELECT_ACTION:
		grid_controller.highlight_action(action)


func _on_action_menu_hud_action_pressed(action: Action) -> void:
	print("Action button was pressed: ", action.action_name)
	state_controller.action_button_pressed(action)


func _on_state_controller_unit_hovered_over_cell(unit: Unit, cell: Cell) -> void:
	unit.hover_over_cell(cell)
	unit_hud.highlight_unit_hud(unit)
