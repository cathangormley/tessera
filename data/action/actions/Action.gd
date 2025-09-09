## Represents any kind of action a unit can take in battle
## E.g. attacking, healing and other special actions
## Actions are composed of effects: Array[Effect]
extends Resource
class_name Action

@export var name: String
@export var sp_cost: int
@export var description: String = "This is an action"

## The type of target area shape for the action
@export var target: Target

## The list of effects that occur when this action is executed
@export var effects: Array[Effect] = []

## The highlight color of the action
## Typically red for attacks, etc.
@export var highlight_color: Color = Color(1, 0, 0, 0.5)

## How many item charges this action consumes
@export var charges_used: int = 0

var item: Item = null


## Perform the action with user on the area specified
func execute(user: Unit, target_area: CellArea):
	user.stats.current_sp -= sp_cost
	for effect in effects:
		effect.execute(user, target_area)

	if item != null:
		item.consume_charges(charges_used)


func can_execute(user: Unit) -> bool:
	if user.stats.current_sp < sp_cost:
		return false
	# Charges check (only if this action consumes charges and a provider exists)
	if item != null:
		if item.uses_left < charges_used:
			return false
	return true


func set_item(i: Item) -> Action:
	item = i
	return self
