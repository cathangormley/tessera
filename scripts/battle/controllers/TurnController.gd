extends Node
class_name TurnController

signal turn_started(unit: Unit, time: float)
signal turn_ended(unit: Unit, time: float)

## The current battle time
var current_time: float = 0.0

## The maximum number of turns per unit to have on the queue per unit
var queue_turns_per_unit: int = 10

## Class representing an upcoming turn:
##
## Contains the unit and the time of the turn
class TurnEvent:
	var unit: Unit
	var time: float

	
	func _init(_unit: Unit, _time: float) -> void:
		unit = _unit
		time = _time


## The queue of turns, always sorted by time
var turn_queue: Array[TurnEvent] = []
## The unit whose turn it is now
var turn_unit: Unit = null


func add_unit(unit: Unit) -> void:
	for i in range(queue_turns_per_unit):
		add_turn_event(unit)


## Add one TurnEvent for the given unit to the turn queue
func add_turn_event(unit: Unit) -> void:
	# Find the unit's last scheduled event
	var last_time: float = current_time
	for event in turn_queue:
		if event.unit == unit:
			last_time = event.time

	# Schedule the new event
	turn_queue.append(TurnEvent.new(unit, last_time + unit.stats.cooldown + randf()))

	# Keep queue sorted by time
	turn_queue.sort_custom(func(a, b): return a.time < b.time)


func remove_unit(unit: Unit) -> void:
	var new = turn_queue.filter(func(te: TurnEvent): return te.unit != unit)
	turn_queue = new


func start_turn() -> void:
	var current_turn: TurnEvent = turn_queue[0] as TurnEvent
	turn_unit = current_turn.unit
	current_time = current_turn.time
	add_turn_event(turn_unit)
	turn_started.emit(turn_unit, current_time)


func end_turn() -> void:
	turn_unit = null
	var turn = turn_queue.pop_front() as TurnEvent
	await get_tree().process_frame # Awful hack to avoid stack overflow
	turn_ended.emit(turn.unit, turn.time)
