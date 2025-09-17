## Effect representing anything where the user tries to hit the units in the target area
extends EffectTargeting
class_name EffectHit

@export var hit: int

@export var on_hit_effects: Array[EffectTargeting]


func effect_on_target(user: Unit, target_unit: Unit) -> void:
	var hit_percentage: int = get_hit(user, target_unit).result
	var is_hit := Utils.roll_percentage(hit_percentage)
	if is_hit:
		for effect in on_hit_effects:
			effect.effect_on_target(user, target_unit)
	else:
		on_miss(user, target_unit)


## Display user's hit rate and the forecast of all the on-hit effects
func get_forecast(user: Unit) -> String:
	var hit: StatCalculation = get_user_hit(user)
	var lines: Array[String] = ["Hit: %s%%" % hit.result]
	for effect in on_hit_effects:
		lines.append("  " + effect.get_forecast(user))
	return "\n".join(lines)


func get_user_hit(user: Unit) -> StatCalculation:
	var user_hit := StatCalculation.new(hit)
	user_hit.add_modifier(null, "Hit", func(): return user.stats.hit.result)
	# Hit Skills
	# ...
	return user_hit


func get_hit(user: Unit, target_unit: Unit) -> StatCalculation:
	var user_hit := get_user_hit(user)
	user_hit.add_modifier(null, "Dodge", func(): return -target_unit.stats.dodge.result)
	# Target Unit Dodge Skills
	# ...
	return user_hit


## What happens when the user misses
func on_miss(user: Unit, target_unit: Unit) -> void:
	print(target_unit.unit_name + " dodges")
	show_miss_splash(target_unit)
