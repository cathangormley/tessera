extends SkillBehavior
class_name SkillBehaviorVigorous

## +1 VIG
func on_equip(unit: Unit, skill: Skill) -> void:
	unit.stats.vigor.add_modifier(skill, skill.name, func(): return 1)
