## Chases the nearest player unit
## Attacks with the strongest attack it can do
extends AI
class_name AIChaser


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
	var target_units: Array[Unit] = coa.target_area.get_units()
	
	for effect in coa.action.effects:
		if effect is EffectTargeting:
			for target_unit in target_units:
				action_value += get_targeting_effect_value(effect, target_unit)
		# if effect is some other effect: like creating terrain, summoning etc.:
		# will need its own evalulation
	
	return action_value


func get_targeting_effect_value(targeting_effect: EffectTargeting, target_unit: Unit) -> float:
	# TODO! A "care index" to generalise this multiplier:
	# By default, +1 for allies and -1 for enemies 
	# But maybe -3 for enemies with a grudge and +3 for close allies for example
	# This could also make the AI "smarter" by encouraging teamwork in particular ways
	var care_index = 2 * int(unit.is_friendly_unit(target_unit)) - 1
	
	if targeting_effect is EffectDamage:
		var estimated_damage = (
			targeting_effect
			.get_damage_range(unit, target_unit)
			.get_result_range()
			.average()
		)
		return -care_index * estimated_damage

	if targeting_effect is EffectHeal:
		var estimated_heal = (
			targeting_effect
			.get_heal_range(unit, target_unit)
			.get_result_range()
			.average()
		)
		return care_index * estimated_heal
	
	if targeting_effect is EffectHit:
		var estimated_hit = targeting_effect.get_hit(unit, target_unit).result
		var total_value := 0.0
		for effect in targeting_effect.on_hit_effects:
			total_value += get_targeting_effect_value(effect, target_unit)
		total_value *= float(estimated_hit) / 100.0
		return total_value
	
	return 0.0


func get_course_of_action_move_value(grid: Array, coa: CourseOfAction, closest_enemy_unit: Unit) -> float:
	if closest_enemy_unit == null:
		return 0.0
	else:
		return -closest_enemy_unit.cell.get_raw_distance_to(coa.move) / 100.0
