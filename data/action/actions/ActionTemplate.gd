## Represents any kind of action a unit can take in battle
## E.g. attacking, healing and other special actions
## Actions are composed of effects: Array[Effect]
## This represents a template of an action
extends Resource
class_name ActionTemplate

@export var action_name: String
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


func to_action() -> Action:
	return Action.new().use_action_template(self)
