## Effect representing dealing damage to units in the target area
extends EffectTargeting
class_name EffectHeal

@export var base_heal_min: int
@export var base_heal_max: int

@export var scaling_attributes: Dictionary[AttributeArray.Attribute, float]


## Deal damage to all units in the target area
func effect_on_target(user: Unit, target_unit: Unit) -> void:
	var heal_range = get_heal_range(user)
	var heal = heal_range.roll_result()
	# Heal can never be negative
	if heal < 0: heal = 0
	print(target_unit.unit_name + " heals " + str(heal) + " damage.")
	show_damage_splash(target_unit, heal)
	target_unit.heal_damage(heal)


func get_forecast(user: Unit) -> String:
	var heal_range = get_heal_range(user)
	return "Heal: %s" % heal_range.get_result_range()


func get_heal_range(user: Unit) -> RangeCalculation:
	# Base heal
	var range_calculation = RangeCalculation.new(IntRange.new(base_heal_min, base_heal_max))
	# Attribute scaling
	for attribute in scaling_attributes:
		var attr_name := AttributeArray.attribute_names_short[attribute]
		range_calculation.add_modifier(null, attr_name,
			func():
				var attr_value := user.stats.attributes.get_attr(attribute)
				var attr_mult := scaling_attributes[attribute]
				return IntRange.constant(attr_value).multiply(attr_mult)
		)
	# Skills ...
	# ... 
	return range_calculation
