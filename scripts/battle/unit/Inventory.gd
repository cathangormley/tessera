extends Node
class_name Inventory

## The items in the unit's inventory, including the armor it has equipped
var items: Array[Item]

## The armor slots available to the unit, usually determined by race
var armor_slots: Array[Body.ArmorSlot]

## The armor equipped by the unit
var armor: Dictionary[Body.ArmorSlot, ItemArmor]

## Setup the armor slots based on the unit's race
func create_armor_slots(race: Race) -> void:
	armor_slots = race.body.armor_slots
	armor.clear()
	for slot in armor_slots:
		armor[slot] = null


func add_item(item: Item) -> void:
	items.append(item)
	item.depleted.connect(_on_item_depleted)


func remove_item(item: Item) -> void:
	items.erase(item)


func _on_item_depleted(item: Item) -> void:
	print(item.item_name, " was depleted")
	remove_item(item)


func equip(item: ItemArmor) -> bool:
	assert(item.armor_slot in armor_slots, "Tried equipping armor without armor slot")
	armor[item.armor_slot] = item
	return true


func unequip(slot: Body.ArmorSlot) -> void:
	armor[slot] = null


var actions: Array[Action]:
	get():
		var ac: Array[Action]
		for item in items:
			ac.append_array(item.actions)
		return ac
