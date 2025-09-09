## A collection of hooks that a skill may have
## Each skill will modify one or more of these hooks
extends Resource
class_name SkillBehavior


func on_equip(unit: Unit) -> void:
	pass


func on_unequip(unit: Unit) -> void:
	pass


func modify_vigor(vigor: int) -> int:
	return vigor


func modify_strength(strength: int) -> int:
	return strength


func modify_dexterity(dexterity: int) -> int:
	return dexterity


func modify_agility(agility: int) -> int:
	return agility


func modify_intellect(intellect: int) -> int:
	return intellect


func modify_faith(faith: int) -> int:
	return faith


func modify_carry_capacity(carry_capacity: int) -> int:
	pass
	return carry_capacity


func modify_flying(flying: bool) -> bool:
	return flying


func modify_physical_defense(def: int) -> int:
	return def


func modify_elemental_defense(def: int) -> int:
	return def
