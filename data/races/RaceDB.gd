extends Resource
class_name RaceDB

enum CoreRace { HUMAN, ELF, DWARF, }

static var core_races: Dictionary[CoreRace, Race] = {
	CoreRace.HUMAN: preload("res://data/races/human.tres"),
	CoreRace.ELF: preload("res://data/races/elf.tres"),
	CoreRace.DWARF: preload("res://data/races/dwarf.tres"),
}
