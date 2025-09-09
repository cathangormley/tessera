extends Node
class_name UnitController

signal unit_removed(unit: Unit, old_cell: Cell)
signal unit_added(unit: Unit, new_cell: Cell)

var units: Array[Unit] = []

@onready var grid_controller = %GridController
@onready var battle = owner
@onready var unit_generator: UnitGenerator = %UnitGenerator

var sword = load("res://data/items/weapons/sword.tres")
var bow = load("res://data/items/weapons/bow.tres")
var staff = load("res://data/items/weapons/staff.tres")
var hp_potion = load("res://data/items/consumables/hp_potion.tres")
var fire_staff = load("res://data/items/weapons/fire_staff.tres")

@export var levin: ItemData

@export var race_human: Race

@export var job_warrior: Job

func create_units() -> void:
	
	var me = unit_generator.generate_player_unit(3)
	me.add_unit_data("Cathan")

	me.add_item_to_inventory(Item.new(sword))
	me.add_item_to_inventory(Item.new(bow))
	me.add_item_to_inventory(Item.new(levin))
	add_unit(me, grid_controller.grid[1][1])
	
	var player2 := unit_generator.generate_player_unit(3)
	player2.add_unit_data("Bobby")

	player2.add_item_to_inventory(Item.new(sword))
	player2.add_item_to_inventory(Item.new(staff))
	player2.add_item_to_inventory(Item.new(hp_potion))
	player2.add_item_to_inventory(Item.new(fire_staff))
	
	add_unit(player2, grid_controller.grid[1][2])
	
	var cobh := unit_generator.generate_ai_unit(1)
	cobh.add_item_to_inventory(Item.new(sword))

	cobh.add_unit_data("Cobh", AIChaser.new(cobh))
	
	var siomh := unit_generator.generate_ai_unit(1)
	siomh.add_item_to_inventory(Item.new(sword))
	siomh.add_unit_data("Siomh", AIChaser.new(siomh))
	
	add_unit(cobh, grid_controller.grid[5][5])
	add_unit(siomh, grid_controller.grid[5][6])


func connect_unit_signals(unit: Unit) -> void:
	# Perhaps the 'correct' pattern here would be to connect the unit signals
	# to a unit_controller func that emits its own signal which the battle
	# node would connect to
	unit.unit_moved.connect(battle._on_unit_moved)
	unit.action_executed.connect(battle._on_action_executed)
	unit.unit_died.connect(remove_unit)


func add_unit(unit: Unit, new_cell: Cell) -> void:
	units.append(unit)
	add_child(unit)
	unit.add_to_cell(new_cell)
	connect_unit_signals(unit)
	unit_added.emit(unit, new_cell) # Maybe move these signals into Unit?

func remove_unit(unit: Unit) -> void:
	var old_cell = unit.cell
	units.erase(unit)
	remove_child(unit)
	unit.remove_from_cell(old_cell)
	unit_removed.emit(unit, old_cell) # Maybe move these signals into Unit?


func calculate_reachable_cells() -> void:
	for unit in units:
		unit.update_reachable_cells_and_paths()


func generate_player_unit(level: int) -> void:
	pass
	# me.generate_stats(AttributeArray.ZERO, race_human, job_warrior, 5)
