## Deal damage to the units in the target area[br]
## Damage is in a range and can scale with user attributes
extends EffectTargeting
class_name EffectDamage

@export var min_damage: int
@export var max_damage: int

@export var scaling_attributes: Dictionary[AttributeArray.Attribute, float]

@export var damage_type: DamageType = preload("res://data/damage/physical/damage_bludgeoning.tres")


## What happens when the user hits
func effect_on_target(user: Unit, target_unit: Unit):
	var damage_range := get_damage_range(user, target_unit)
	var damage := damage_range.roll_result()
	# Damage can never be negative
	if damage < 0: damage = 0
	print(target_unit.unit_name + " takes " + str(damage) + " damage.")
	show_damage_splash(target_unit, damage)
	target_unit.take_damage(damage)


func get_forecast(user: Unit) -> String:
	var damage_range = get_user_damage_range(user)
	return "Damage: %s" % damage_range.get_result_range()

#
#func calculate_damage(user: Unit, target_unit: Unit) -> int:
	#var damage := randi_range(min_damage, max_damage)
	## Add e.g. unit's strength to damage
	#for attr in scaling_attributes:
		#damage += int(scaling_attributes[attr] * user.stats.attributes.get_attr(attr))
	## TODO! Defense of target unit
	#match damage_type.type:
		#DamageType.Type.PHYSICAL: damage -= target_unit.stats.physical_defense.result
		#DamageType.Type.ELEMENTAL: damage -= target_unit.stats.elemental_defense.result
#
	#if damage < 0: damage = 0
	#return damage

## Calculate the damage range and roll, returning the result
func get_damage_range(user: Unit, target_unit: Unit) -> RangeCalculation:
	# User's damage output
	var damage_range := get_user_damage_range(user)
	# Target unit's defense
	var defense: int = 0
	match damage_type.type:
		DamageType.Type.PHYSICAL: defense = target_unit.stats.physical_defense.result
		DamageType.Type.ELEMENTAL: defense = target_unit.stats.elemental_defense.result
	damage_range.add_modifier(null, "Defense", func(): return IntRange.constant(-defense))
	# Defensive Skills ...
	# ...
	return damage_range


## Get the output damage_range from the user
func get_user_damage_range(user: Unit) -> RangeCalculation:
	# Base damage
	var range_calculation = RangeCalculation.new(IntRange.new(min_damage, max_damage))
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
