## This represents a stat calculation, which is a special case of range calculation
## where the ranges are all constant. Used in calculating stats for example.
extends RangeCalculation
class_name StatCalculation

var result: int:
	get():
		return get_result_range().min_value


func _init(base_value: int = 0, base_source: Object = null,
		base_label: String = "Base") -> void:
	super._init(IntRange.constant(base_value), base_source, base_label)
