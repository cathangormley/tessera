extends SkillBehavior
class_name SkillBehaviorStrong

## +1 STR
func on_equip(unit: Unit, skill: Skill) -> void:
	unit.stats.strength.add_modifier(skill, skill.name, func(): return 1)
