## Changes the target unit's stats, either as a buff or debuff
extends EffectTargeting
class_name EffectChangeAttribute

## Delta in attributes
@export var attribute_change: Dictionary[AttributeArray.Attribute, int]
## Time before change expires
@export var duration: float


func effect_on_target(user: Unit, target_unit: Unit) -> void:
	for attribute in attribute_change:
		var target_unit_attribute := (target_unit.stats.get(
			AttributeArray.attribute_names[attribute])) as StatCalculation
		var expiration_time: float = target_unit.turn_controller.current_time + duration
		target_unit_attribute.add_modifier(self, "Buff",
			func(): return attribute_change[attribute],
			RangeModifier.Mode.ADD, expiration_time)


## Shows a forecast of what the effect will do
func get_forecast(user: Unit) -> String:
	var forecast: Array[String] = []
	for attribute in attribute_change:
		var attr := AttributeArray.attribute_names_short[attribute]
		forecast.append(attr + ": " + str(attribute_change[attribute]))
	return "\n".join(forecast)
