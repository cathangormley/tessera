extends Control
class_name ActionMenuHUD

signal menu_exited()
signal action_hovered(action: Action)
signal action_pressed(action: Action)


## Control node covering the entire screen to block
## all mouse input while a menu is open 
@onready var screen: Control = %Screen

## Menu displaying categories: Item, Job, Race, Skill, General
var action_menu_scene := preload("res://scenes/ui/action_menu/action_menu.tscn")
## Menu displaying items in inventory with actions
var item_menu_scene := preload("res://scenes/ui/action_menu/item_menu.tscn")
## Menu displaying list of actions
var action_submenu_scene := preload("res://scenes/ui/action_menu/action_submenu.tscn")

## State for tracking where "going back" goes
enum State { NULL, MAIN, ITEM, ITEM_ACTION, OTHER_ACTION, }
var state = State.NULL


func open_action_menu(unit: PlayerUnit) -> void:
	free_menu(unit)
	
	var action_menu: ActionMenu = action_menu_scene.instantiate()
	add_menu_to_tree(action_menu, unit)
	
	action_menu.button_pressed.connect(_on_button_pressed.bind(unit))
	action_menu.cancel_pressed.connect(cancel.bind(unit))
	
	state = State.MAIN


func open_item_menu(unit: PlayerUnit) -> void:
	free_menu(unit)
	
	var item_menu: ItemMenu = item_menu_scene.instantiate()
	add_menu_to_tree(item_menu, unit)
	item_menu.display_items(unit)
	
	item_menu.item_button_pressed.connect(_on_item_button_pressed.bind(unit))
	item_menu.cancel_pressed.connect(cancel.bind(unit))
	
	state = State.ITEM


func open_action_submenu(actions: Array[Action], unit: PlayerUnit, is_item_action: bool = false) -> void:
	free_menu(unit)
	
	var action_submenu: ActionSubmenu = action_submenu_scene.instantiate()
	add_menu_to_tree(action_submenu, unit)
	action_submenu.display_actions(actions, unit)
	
	action_submenu.action_button_hovered.connect(_on_action_button_hovered.bind(unit))
	action_submenu.action_button_pressed.connect(_on_action_button_pressed.bind(unit))
	action_submenu.cancel_pressed.connect(cancel.bind(unit))
	
	state = State.OTHER_ACTION
	if is_item_action: state = State.ITEM_ACTION


func _on_action_button_hovered(action: Action, unit: PlayerUnit) -> void:
	action_hovered.emit(action)


func _on_action_button_pressed(action: Action, unit: PlayerUnit) -> void:
	free_menu(unit)
	action_pressed.emit(action)


## For positioning, we add the menu under the player node
func add_menu_to_tree(menu: Node2D, unit: PlayerUnit) -> void:
	unit.action_menu_container.add_child(menu)
	menu.name = "Menu"
	menu.global_position = unit.hovered_cell.global_position


func free_menu(unit: PlayerUnit) -> void:
	for node in unit.action_menu_container.get_children():
		node.queue_free()


func _on_button_pressed(option: ActionMenu.ButtonOption, unit: PlayerUnit) -> void:
	print("Button pressed: ", option)
	
	match option:
		ActionMenu.ButtonOption.ITEM: open_item_menu(unit)
		ActionMenu.ButtonOption.JOB: open_action_submenu(unit.job_actions, unit)
		ActionMenu.ButtonOption.RACE: open_action_submenu(unit.race_actions, unit)
		ActionMenu.ButtonOption.SKILL: open_action_submenu(unit.skill_actions, unit)
		ActionMenu.ButtonOption.GENERAL: open_action_submenu(unit.general_actions, unit)


func _on_item_button_pressed(item: Item, unit: PlayerUnit) -> void:
	print("Item pressed: ", item.item_name)
	open_action_submenu(item.actions, unit, true)


## Back out of menu by one level (e.g. by selecting cancel or right-clicking) 
func cancel(unit: PlayerUnit) -> void:
	var new_state: State = State.NULL
	
	match state:
		State.MAIN: new_state = State.NULL
		State.ITEM: new_state = State.MAIN
		State.ITEM_ACTION: new_state = State.ITEM
		State.OTHER_ACTION: new_state = State.MAIN
	
	match new_state:
		State.NULL:
			free_menu(unit)
			menu_exited.emit()
		State.MAIN: open_action_menu(unit)
		State.ITEM: open_item_menu(unit)
		_: assert(false, "Unexpected action menu state")
