extends Node
class_name Item

signal depleted(item: Item)

var item_data: ItemData

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


func _init(_item_data: ItemData) -> void:
	item_data = _item_data
	
	item_name = item_data.item_name
	description = item_data.description
	weight = item_data.weight
	
	max_uses = item_data.uses
	uses_left = max_uses
	
	for action in item_data.actions:
		actions.append((action.duplicate() as Action).set_item(self))


func consume_charges(n: int = 1) -> void:
	uses_left -= n 
