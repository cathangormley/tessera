extends ItemTemplate
class_name ItemArmorTemplate

@export var armor_slot: Body.ArmorSlot

@export var physical_defense: int
@export var elemental_defense: int

# Maybe it makes sense to model special effects from armor as skills?
# var skills: Array[Skill]?

func to_item() -> ItemArmor:
	return ItemArmor.new().use_item_armor_template(self)
