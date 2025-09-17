## A collection of hooks that a skill may have
## Each skill will modify one or more of these hooks
extends Resource
class_name SkillBehavior


func on_equip(unit: Unit, skill: Skill) -> void:
	pass


func on_unequip(unit: Unit) -> void:
	pass


func modify_flying(flying: bool) -> bool:
	return flying


func modify_hit(user: Unit, hit: StatCalculation) -> StatCalculation:
	return hit
