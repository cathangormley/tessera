extends SkillBehavior
class_name SkillBehaviorIntellectual

## +1 INT
func on_equip(unit: Unit, skill: Skill) -> void:
	unit.stats.intellect.add_modifier(skill, skill.name, func(): return 1)
