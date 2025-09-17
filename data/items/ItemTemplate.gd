## The template of an item
extends Resource
class_name ItemTemplate

# Properties of the item
@export var item_name: String
@export var description: String
@export var weight: int

## The list of actions this item grants the unit
@export var action_templates: Array[ActionTemplate] = []

@export var uses: int = 1


func to_item() -> Item:
	return Item.new().use_item_template(self)
