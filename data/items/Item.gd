## An actual item instance
extends Node
class_name Item

signal depleted(item: Item)

# The item template that was used to construct this item; may be null
var item_template: ItemTemplate

# Properties of the item
var item_name: String
var description: String
var weight: int

var max_uses: int = 1
var uses_left: int = 1:
	set(value):
		uses_left = value
		if uses_left <= 0:
			depleted.emit(self)

## The list of actions this item grants the unit
var actions: Array[Action] = []


func use_item_template(_item_template: ItemTemplate) -> Item:
	item_template = _item_template
	
	item_name = _item_template.item_name
	description = _item_template.description
	weight = _item_template.weight
	
	max_uses = _item_template.uses
	uses_left = _item_template.uses
	
	for action_template in _item_template.action_templates:
		actions.append(
			action_template.to_action().set_item(self)
		)
	
	return self


func consume_charges(n: int = 1) -> void:
	uses_left -= n 
