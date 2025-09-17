extends SkillBehavior
class_name SkillBehaviorDextrous

## +1 DEX
func on_equip(unit: Unit, skill: Skill) -> void:
	unit.stats.dexterity.add_modifier(skill, skill.name, func(): return 1)
