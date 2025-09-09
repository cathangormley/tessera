## This class handles all the stats logic for the unit
## This includes their race, their job, etc.
extends Node
class_name Stats

signal died()

## The unit that these stats belong to
@export var unit: Unit

## The raw stats the unit has without modifiers
var base_attributes: AttributeArray

var race: Race

var job: Job
var job_level: int

var skills: Array[Skill]

var attributes: AttributeArray: get = get_attributes


func get_attributes() -> AttributeArray:
	var attrs: AttributeArray = AttributeArray.ZERO
	attrs = attrs.add(base_attributes)
	if job != null:
		attrs = attrs.add(job.attribute_growths.multiply(job_level))
	if race != null:
		attrs = attrs.add(race.attributes)

	for skill in skills:
		attrs._vigor = skill.behavior.modify_vigor(attrs._vigor)
		attrs._strength = skill.behavior.modify_strength(attrs._strength)
		attrs._dexterity = skill.behavior.modify_dexterity(attrs._dexterity)
		attrs._agility = skill.behavior.modify_agility(attrs._agility)
		attrs._intellect = skill.behavior.modify_intellect(attrs._intellect)
		attrs._faith = skill.behavior.modify_faith(attrs._faith)
	
	return attrs


## Core Attributes
var vigor: int:
	get: return int(attributes.get_attr(AttributeArray.Attribute.VIG))
var strength: int:
	get: return int(attributes.get_attr(AttributeArray.Attribute.STR))
var dexterity: int:
	get: return int(attributes.get_attr(AttributeArray.Attribute.DEX))
var agility: int:
	get: return int(attributes.get_attr(AttributeArray.Attribute.AGI))
var intellect: int:
	get: return int(attributes.get_attr(AttributeArray.Attribute.INT))
var faith: int:
	get: return int(attributes.get_attr(AttributeArray.Attribute.FAI))

# Derived Stats
var base_movement: int = 5

var max_hp: int: get = get_max_hp
var max_sp: int: get = get_max_sp
var cooldown: float: get = get_cooldown

enum Encumbrance { LIGHT, MEDIUM, HEAVY, }

var carry: int: get = get_carry
var carry_capacity: int: get = get_carry_capacity
var encumbrance: Encumbrance: get = get_encumbrance
var movement: int: get = get_movement

var current_hp: int: set = set_current_hp

var current_sp: int:
	set(value):
		current_sp = clampi(value, 0, max_sp)

## The bonus to hit chance in percent
var hit: int: get = get_hit
## The bonus to dodge chance in percent
var dodge: int: get = get_dodge

func get_max_hp() -> int:
	var base_hp := 10
	var job_hp := job_level * maxi(job.hp + vigor, 0)
	return base_hp + job_hp


func get_max_sp() -> int:
	return 20 + intellect


func get_cooldown() -> float:
	return 10.0 - float(agility) / 10.0


func get_hit() -> int:
	return 2 * dexterity


func get_dodge() -> int:
	return 2 * agility


func get_carry() -> int:
	var total_weight := 0
	for item in unit.inventory.items:
		total_weight += item.weight
	return total_weight


func get_carry_capacity() -> int:
	return 15 + 2 * strength


func get_encumbrance() -> int:
	var carry_proportion = float(carry) / float(carry_capacity)
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
	current_hp = clampi(value, 0, max_hp)
	if current_hp == 0:
		died.emit()


var flying: bool:
	get():
		var is_flying := race.flying
		for skill in skills:
			is_flying = skill.behavior.modify_flying(is_flying)
		return is_flying


var physical_defense: int:
	get():
		var def := 0
		for armor: ItemArmor in unit.inventory.armor.values():
			if armor == null: continue
			def += armor.physical_defense
		for skill in skills:
			def = skill.behavior.modify_physical_defense(def)
		return def


var elemental_defense: int:
	get():
		var def := 0
		for armor: ItemArmor in unit.inventory.armor.values():
			if armor == null: continue
			def += armor.elemental_defense
		for skill in skills:
			def = skill.behavior.modify_elemental_defense(def)
		return def


func generate_stats(_base_attrs: AttributeArray, _race: Race, _job: Job, _job_level: int):
	base_attributes = _base_attrs
	race = _race
	job = _job
	job_level = _job_level
	
	current_hp = max_hp
	current_sp = max_sp


func add_skill(skill: Skill) -> void: skills.append(skill)
