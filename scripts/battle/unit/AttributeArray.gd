extends Resource
class_name AttributeArray

## Typically:
## Physical weapons:	DEX to hit / STR to damage
## Arcane magic:		DEX to hit (if appl.) / INT scaling
## Divine magic:		DEX to hit (if appl.) / FAI scaling

## Vigor:		HP, ???
## Strength:	Phys. Scaling, Carry Capacity
## Dexterity:	Melee Hit, Ranged Hit
## Agility:		Dodge, Cooldown
## Intellect:	Arc. Scaling, SP
## Faith:		Div. Scaling, ???

enum Attribute { VIG, STR, DEX, AGI, INT, FAI }

static var attribute_names: Dictionary[Attribute, String] = {
	Attribute.VIG: "vigor",
	Attribute.STR: "strength",
	Attribute.DEX: "dexterity",
	Attribute.AGI: "agility",
	Attribute.INT: "intellect",
	Attribute.FAI: "faith",
}

static var attribute_names_short: Dictionary[Attribute, String] = {
	Attribute.VIG: "VIG",
	Attribute.STR: "STR",
	Attribute.DEX: "DEX",
	Attribute.AGI: "AGI",
	Attribute.INT: "INT",
	Attribute.FAI: "FAI",
}

## Core Attributes
@export var _vigor: int
@export var _strength: int
@export var _dexterity: int
@export var _agility: int
@export var _intellect: int
@export var _faith: int

var array: Array[int]:
	get():
		return [_vigor, _strength, _dexterity, _agility, _intellect, _faith]


func get_attr(attr: Attribute) -> int:
	match attr:
		Attribute.VIG: return _vigor
		Attribute.STR: return _strength
		Attribute.DEX: return _dexterity
		Attribute.AGI: return _agility
		Attribute.INT: return _intellect
		Attribute.FAI: return _faith
		_: # Should never happen
			assert(false)
			return 0


static var ZERO: AttributeArray = AttributeArray.from_array([0, 0, 0, 0, 0, 0])


static func from_array(array: Array[int]) -> AttributeArray:
	assert(array.size() == 6, "Tried to create AttributeArray from array of incorrect length")
	
	var attr_array =  AttributeArray.new()
	
	attr_array._vigor = array[0]
	attr_array._strength = array[1]
	attr_array._dexterity = array[2]
	attr_array._agility = array[3]
	attr_array._intellect = array[4]
	attr_array._faith = array[5]

	return attr_array


func to_array() -> Array[float]:
	var array: Array[float]
	array.assign(Attribute.values().map(get_attr))
	return array


## Returns an attribute array with elements equal to the sum of the attributes of two attribute arrays
func add(attr_array: AttributeArray) -> AttributeArray:
	if attr_array == null: return self
	var sum_array: Array[int]
	# For performance, we put these in explicit variables
	var array1 := array
	var array2 := attr_array.array
	for i in array1.size():
		sum_array.append(array1[i] + array2[i])
	return AttributeArray.from_array(sum_array)


## Returns an attribute array with elements multiplied by mult
func multiply(mult: float) -> AttributeArray:
	var mult_array := array
	for i in mult_array.size():
		mult_array[i] = int(mult * mult_array[i])
	return AttributeArray.from_array(mult_array)
