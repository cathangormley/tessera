extends SkillBehavior
class_name SkillBehaviorFaithful

## +1 FAI
func on_equip(unit: Unit, skill: Skill) -> void:
	unit.stats.faith.add_modifier(skill, skill.name, func(): return 1)
