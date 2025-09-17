extends SkillBehavior
class_name SkillBehaviorAgile

## +1 AGI
func on_equip(unit: Unit, skill: Skill) -> void:
	unit.stats.agility.add_modifier(skill, skill.name, func(): return 1)
