## Chases the nearest player unit
## Attacks with the strongest attack it can do
extends AI
class_name AIChaser


## WIP obviously
func choose_course_of_action(grid: Array) -> CourseOfAction:
	var coas := get_all_courses_of_action()
	var closest_enemy_unit: Unit = get_closest_enemy_unit_by_raw_distance(grid)
	
	var best_coa: CourseOfAction
	var best_coa_value: float = -INF
	for coa in coas:
		var action_value = get_course_of_action_action_value(grid, coa)
		var move_value = get_course_of_action_move_value(grid, coa, closest_enemy_unit)
		var value = action_value + move_value
		if value > best_coa_value:
			best_coa_value = value
			best_coa = coa
	
	return best_coa


func get_course_of_action_action_value(grid: Array, coa: CourseOfAction) -> float:
	var action_value: float = 0.0
	for effect in coa.action.effects:
		if effect is EffectHitForDamage:
			var enemy_target_units = coa.target_area.get_units().filter(unit.is_enemy_unit)
			action_value += len(enemy_target_units) * (effect as EffectHitForDamage).ev_damage
	
		if effect is EffectHeal:
			var friendly_target_units = coa.target_area.get_units().filter(unit.is_friendly_unit)
			action_value += len(friendly_target_units) * (effect as EffectHeal).ev_heal
	
	return action_value


func get_course_of_action_move_value(grid: Array, coa: CourseOfAction, closest_enemy_unit: Unit) -> float:
	if closest_enemy_unit == null:
		return 0.0
	else:
		return -closest_enemy_unit.cell.get_raw_distance_to(coa.move) / 100.0
