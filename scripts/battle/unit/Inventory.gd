extends Node
class_name Inventory

@export var unit: Unit

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


func equip_armor(item: ItemArmor) -> bool:
	assert(item.armor_slot in armor_slots, "Tried equipping armor without armor slot")
	armor[item.armor_slot] = item
	unit.stats.physical_defense.add_modifier(item, item.item_name, func(): return item.physical_defense)
	unit.stats.elemental_defense.add_modifier(item, item.item_name, func(): return item.elemental_defense)
	return true


func unequip_armor(slot: Body.ArmorSlot) -> void:
	var item := armor[slot]
	unit.stats.physical_defense.remove_source_from_modifiers(item)
	unit.stats.elemental_defense.remove_source_from_modifiers(item)
	armor[slot] = null


var actions: Array[Action]:
	get():
		var ac: Array[Action]
		for item in items:
			ac.append_array(item.actions)
		return ac
