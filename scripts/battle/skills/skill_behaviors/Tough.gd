extends SkillBehavior
class_name SkillBehaviourTough


## +1 Phys. Defense
func on_equip(unit: Unit, skill: Skill) -> void:
	unit.stats.physical_defense.add_modifier(skill, skill.name, func(): return 1)
