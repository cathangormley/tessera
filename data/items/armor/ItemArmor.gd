extends Item
class_name ItemArmor

@export var armor_slot: Body.ArmorSlot

@export var physical_defense: int
@export var elemental_defense: int


func use_item_armor_template(_item_armor_template: ItemArmorTemplate) -> ItemArmor:
	super.use_item_template(_item_armor_template)
	
	armor_slot = _item_armor_template.armor_slot
	physical_defense = _item_armor_template.physical_defense
	elemental_defense = _item_armor_template.elemental_defense
	
	return self
