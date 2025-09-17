extends SkillBehavior
class_name SkillBehaviourHillFighter


func on_equip(unit: Unit, skill: Skill) -> void:
	unit.stats.hit.add_modifier(skill, skill.name, condition.bind(unit))


func condition(unit: Unit) -> int:
	if unit.hovered_cell.tile.name == "Hill":
		return 10
	return 0
