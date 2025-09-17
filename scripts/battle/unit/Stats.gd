## This class handles all the stats logic for the unit
## This includes their race, their job, etc.
extends Node
class_name Stats

signal died()

## The unit that these stats belong to
@export var unit: Unit

var race: Race

var job: Job
var job_level: int

var skills: Array[Skill]

var attributes: AttributeArray:
	get():
		return AttributeArray.from_array([vigor.result, strength.result,
				dexterity.result, agility.result,
				intellect.result,faith.result])

var attrs: Dictionary


func get_attribute_map() -> Dictionary:
	return {
		AttributeArray.Attribute.VIG: vigor,
		AttributeArray.Attribute.STR: strength,
		AttributeArray.Attribute.DEX: dexterity,
		AttributeArray.Attribute.AGI: agility,
		AttributeArray.Attribute.INT: intellect,
		AttributeArray.Attribute.FAI: faith,
	}


## Core Attributes
var vigor: StatCalculation
var strength: StatCalculation
var dexterity: StatCalculation
var agility: StatCalculation
var intellect: StatCalculation
var faith: StatCalculation

# Derived Stats
var base_movement: int = 5


var max_hp := (
	StatCalculation.new(10)
		.add_modifier(null, "Job", func(): return job_level * job.hp)
		.add_modifier(null, "Vigor", func(): return job_level * vigor.result)
)
var max_sp := (
	StatCalculation.new(20)
		.add_modifier(null, "Intellect", func(): return intellect.result)
)
var speed: StatCalculation = (
	StatCalculation.new(100)
		.add_modifier(null, "Agility", func(): return 5 * agility.result)
)
## TODO! Fix this
var cooldown: float:
	get():
		return 1000.0 / speed.result

enum Encumbrance { LIGHT, MEDIUM, HEAVY, }

var carry_capacity := (
	StatCalculation.new(15)
		.add_modifier(null, "Strength", func(): return 2 * strength.result)
)
var carry: int: get = get_carry
var encumbrance: Encumbrance: get = get_encumbrance
var movement: int: get = get_movement

var current_hp: int: set = set_current_hp

var current_sp: int:
	set(value):
		current_sp = clampi(value, 0, max_sp.result)

## The bonus to hit chance in percent
var hit := (
	StatCalculation.new(0)
		.add_modifier(null, "Dexterity", func(): return 2 * dexterity.result)
)
## The bonus to dodge chance in percent
var dodge := (StatCalculation.new(0)
	.add_modifier(null, "Agility", func(): return 2 * agility.result))


func get_carry() -> int:
	var total_weight := 0
	for item in unit.inventory.items:
		total_weight += item.weight
	return total_weight


func get_encumbrance() -> Encumbrance:
	var carry_proportion = float(carry) / float(carry_capacity.result)
	if carry_proportion <= 0.5:
		return Encumbrance.LIGHT
	if carry_proportion <= 0.75:
		return Encumbrance.MEDIUM
	return Encumbrance.HEAVY


func get_movement() -> int:
	var enc := encumbrance
	match enc:
		Encumbrance.LIGHT: return base_movement
		Encumbrance.MEDIUM: return base_movement - 1
		Encumbrance.HEAVY: return base_movement - 2
		_: return 0


func set_current_hp(value: int) -> void:
	current_hp = clampi(value, 0, max_hp.result)
	if current_hp == 0:
		died.emit()


var flying: bool:
	get():
		var is_flying := race.flying
		for skill in skills:
			is_flying = skill.behavior.modify_flying(is_flying)
		return is_flying


var physical_defense := StatCalculation.new(0)
var elemental_defense := StatCalculation.new(0)


func generate_attribute(base_attributes: AttributeArray, race: Race,
		attribute: AttributeArray.Attribute) -> StatCalculation:
	return (
		StatCalculation.new(base_attributes.get_attr(attribute))
		.add_modifier(null, "Race", func(): return race.attributes.get_attr(attribute))
	)


func generate_stats(base_attributes: AttributeArray, _race: Race, _job: Job, _job_level: int):
	race = _race
	job = _job
	job_level = _job_level
	
	for attr in AttributeArray.attribute_names:
		self.set(AttributeArray.attribute_names[attr],
				generate_attribute(base_attributes, race, attr))
	
	# TODO! Fix this so that on joining the battle a unit has the correct HP/SP
	current_hp = max_hp.result
	current_sp = max_sp.result


func add_skill(skill: Skill) -> void:
	skills.append(skill)
	skill.behavior.on_equip(unit, skill)
