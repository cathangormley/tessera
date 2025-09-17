## Script for randomly generating units
extends Node
class_name UnitGenerator

@export var player_unit_scene: PackedScene = preload("res://scenes/unit/player_unit.tscn")
@export var ai_unit_scene: PackedScene = preload("res://scenes/unit/ai_unit.tscn")

## The weights of any race being chosen
var race_weights: Dictionary[RaceDB.CoreRace, float] = {
	RaceDB.CoreRace.HUMAN: 60,
	RaceDB.CoreRace.ELF: 20,
	RaceDB.CoreRace.DWARF: 20,
}

func generate_player_unit(level: int) -> PlayerUnit:
	var player_unit: PlayerUnit = player_unit_scene.instantiate()
	
	var race := RaceDB.core_races[Utils.choose_weighted(race_weights)]
	var base_attributes := generate_player_base_attributes_array()
	var job := choose_player_job(base_attributes, race)
	
	player_unit.initialize(base_attributes, race, job, level)
	add_skills(player_unit)
	return player_unit


## Generates the base attributes for the player
##
## Uses a standard array in a random order
func generate_player_base_attributes_array() -> AttributeArray:
	var array: Array[int] = [3, 2, 1, 0, 0, -1]
	array.shuffle()
	return AttributeArray.from_array(array)


## Sets base_attributes to be zero
func generate_player_base_attributes_zero() -> AttributeArray:
	return AttributeArray.ZERO


## Chooses what class the unit will be
## Prioritises jobs that the unit will be good at

func choose_player_job(base_attributes: AttributeArray, race: Race) -> Job:
	var weights: Dictionary[Job, float]
	var attribute_array = base_attributes.add(race.attributes).to_array()
	
	# Look at the jobs whose growths correlate with the unit's base_attributes
	# and choose with probability proportional to the correlation
	for job: Job in JobDB.core_jobs.values():
		var corr = Vec.rho(attribute_array, job.attribute_growths.to_array())
		weights[job] = corr
	
	var job: Job = Utils.choose_weighted(weights)
	if job == null: job = JobDB.core_jobs.values()[0]
	
	return job


func generate_ai_unit(level: int) -> AIUnit:
	var ai_unit: AIUnit = ai_unit_scene.instantiate()
	
	var race := RaceDB.core_races[Utils.choose_weighted(race_weights)]
	var base_attributes := generate_player_base_attributes_array()
	var job := choose_player_job(base_attributes, race)
	
	ai_unit.initialize(base_attributes, race, job, level)
	add_skills(ai_unit)
	return ai_unit


func add_skills(unit: Unit) -> void:
	## Get one random skill per level
	var skills := SkillDB.get_random_skills_with_tags([], unit.stats.job_level)
	for skill in skills:
		unit.stats.add_skill(skill)
	
