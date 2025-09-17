## An instance of an action
extends Node
class_name Action

## The template used to create this action; may be null
var action_template: ActionTemplate

var action_name: String
var sp_cost: int
var description: String

## The type of target area shape for the action
var target: Target

## The list of effects that occur when this action is executed
var effects: Array[Effect] = []

## The highlight color of the action
## Typically red for attacks, etc.
var highlight_color: Color = Color(1, 0, 0, 0.5)

## How many item charges this action consumes
var charges_used: int = 0

## The item to which this action belongs; may be null
var item: Item


func use_action_template(_action_template: ActionTemplate) -> Action:
	action_template = _action_template
	
	action_name = _action_template.action_name
	sp_cost = _action_template.sp_cost
	description = _action_template.description

	target = _action_template.target
	highlight_color = _action_template.highlight_color

	charges_used = _action_template.charges_used
	
	for effect in _action_template.effects:
		effects.append(effect.duplicate())
	
	return self


## Perform the action with user on the area specified
func execute(user: Unit, target_area: CellArea) -> void:
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
