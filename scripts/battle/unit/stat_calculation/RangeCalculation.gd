## This represents a range calculation, that is,
## a series of modifiers which are possibly ranges
extends Resource
class_name RangeCalculation

## List of modifiers
# Of course, the order of the modifiers matters
var modifiers: Array[RangeModifier] = []


func _init(base_range: IntRange = IntRange.new(0, 0), base_source: Object = null,
		base_label: String = "Base") -> void:
	modifiers = [RangeModifier.new(base_source, base_label, func(): return base_range)]


func add_modifier(source: Object, label: String, method: Callable,
		mode: RangeModifier.Mode = RangeModifier.Mode.ADD,
		expiration_time: float = INF) -> RangeCalculation:
	modifiers.append(RangeModifier.new(source, label, method, mode, expiration_time))
	return self


## Removes all modifiers with a specified source
func remove_source_from_modifiers(source: Object) -> void:
	modifiers = modifiers.filter(func(m): return m.source != source)


## Get the total final range of possibilities
func get_result_range() -> IntRange:
	var result = IntRange.constant(0)
	for modifier in modifiers:
		result = modifier.apply_modifier(result)
	return result


## Roll to determine the final result
func roll_result() -> int:
	var result: int = 0
	for modifier in modifiers:
		result = modifier.roll_modifier(result)
	return result


# Maybe cache this / update it with modifiers setter
func get_calculation(joiner: String = "\n") -> String:
	var calculation: Array[String] = []
	for modifier in modifiers:
		calculation.append(modifier.get_calculation())
	return joiner.join(calculation)
