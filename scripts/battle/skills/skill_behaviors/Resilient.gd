extends SkillBehavior
class_name SkillBehaviourResilient


## +1 Elem. Defense
func on_equip(unit: Unit, skill: Skill) -> void:
	unit.stats.elemental_defense.add_modifier(skill, skill.name, func(): return 1)
