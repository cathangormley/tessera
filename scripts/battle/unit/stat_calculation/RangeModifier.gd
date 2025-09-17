extends Resource
class_name RangeModifier


## Source of this modifier
var source: Object
## String for displaying the calculation to the player; not a key
var label: String
## The method this modifier calls. This returns a number that is added
## or multiplied to the stat calculation 
var method: Callable
## If the modifier is temporary, we keep track of when is expires here
var expiration_time: float
## Whether the modifier adds, multiplies, etc.
enum Mode { ADD, MULTIPLY }
var mode: Mode


func _init(_source: Object, _label: String, _method: Callable,
		_mode: Mode = Mode.ADD, _expiration_time: float = INF) -> void:
	source = _source
	label = _label
	method = _method
	mode = _mode
	expiration_time = _expiration_time


## Calls the method and checks typing
func call_method():
	var res = method.call()
	match mode:
		Mode.ADD:
			if res is int:
				return IntRange.constant(res)
			if res is IntRange:
				return res
		Mode.MULTIPLY:
			if res is int:
				return float(res)
			if res is float:
				return res
	# If not a recognised type:
	push_error("Unexpected type from method.call()")


## Apply the modifier to the input
func apply_modifier(input: IntRange) -> IntRange:
	var output: IntRange
	var res = call_method()
	
	match mode:
		Mode.ADD:
			output = input.add(res)
		Mode.MULTIPLY:
			output = input.multiply(res)
	return output


func roll_modifier(input: int) -> int:
	var output: int
	var res = call_method()
	
	match mode:
		Mode.ADD:
			output = input + res.roll()
		Mode.MULTIPLY:
			output = int(res * input)
	return output


## The modifier in a human readable format
func get_calculation() -> String:
	var mode_string: String
	match mode:
		Mode.ADD: mode_string = "+"
		Mode.MULTIPLY: mode_string = "*"
	
	var expiration_string: String = ""
	if expiration_time != INF: expiration_string = " (%0.2f)" % expiration_time
	
	var res = call_method()
	return label + ": " + mode_string + str(res) + expiration_string
