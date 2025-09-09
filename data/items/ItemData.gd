## Inventory Items
extends Resource
class_name ItemData

# Properties of the item
@export var item_name: String
@export var description: String
@export var weight: int

## The list of actions this item grants the unit
@export var actions: Array[Action] = []

@export var uses: int = 1
