extends Resource
class_name IntRange

@export var min_value: int
@export var max_value: int


func _init(_min_value: int = 0, _max_value: int = 0):
	min_value = _min_value
	max_value = _max_value


static func constant(value: int = 0) -> IntRange:
	return IntRange.new(value, value)


func add(other: IntRange) -> IntRange:
	return IntRange.new(min_value + other.min_value, max_value + other.max_value)


func multiply(mult: float) -> IntRange:
	# Always round down
	return IntRange.new(int(mult * min_value), int(mult * max_value))


func average() -> float:
	return float(min_value + max_value) / 2.0


## Randomly chooses an int between min_value and max_value
func roll() -> int:
	return randi_range(min_value, max_value)


func _to_string() -> String:
	if min_value == max_value:
		return str(min_value)
	else:
		return str(min_value) + "-" + str(max_value)
