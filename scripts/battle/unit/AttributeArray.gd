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

## Core Attributes
@export var _vigor: float
@export var _strength: float
@export var _dexterity: float
@export var _agility: float
@export var _intellect: float
@export var _faith: float


func get_attr(attr: Attribute) -> float:
	match attr:
		Attribute.VIG: return _vigor
		Attribute.STR: return _strength
		Attribute.DEX: return _dexterity
		Attribute.AGI: return _agility
		Attribute.INT: return _intellect
		Attribute.FAI: return _faith
		_: # Should never happen
			assert(false)
			return 0.0


static var ZERO: AttributeArray = AttributeArray.from_array([0.0, 0.0, 0.0, 0.0, 0.0, 0.0])


static func from_array(array: Array[float]) -> AttributeArray:
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
	return AttributeArray.from_array(Vec.add(to_array(), attr_array.to_array()))


## Returns an attribute array with elements multiplied by mult
func multiply(mult: float) -> AttributeArray:
	var array := to_array()
	for i in array.size():
		array[i] *= mult
	return AttributeArray.from_array(array)
