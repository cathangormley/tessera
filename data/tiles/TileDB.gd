extends Node

@onready var TILES: Dictionary[String, Tile] = {
	"grass": load("res://data/tiles/tiles/grass.tres"),
	"water": load("res://data/tiles/tiles/water.tres"),
	"hill": load("res://data/tiles/tiles/hill.tres"),
	"mountain": load("res://data/tiles/tiles/mountain.tres"),
}

var tiles_directory: String = "res://data/tiles/tiles"

var tiles: Dictionary[String, Tile] = {}


func _ready() -> void:

	load_tiles()


## Loads all tiles in tiles_directory and stores in tiles dictionary[br]
## e.g. "grass" -> load(tiles_directory + "grass.tres")
func load_tiles() -> void:
	var dir := DirAccess.open(tiles_directory)

	dir.list_dir_begin()
	
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tres"):
			tiles[file_name.get_basename()] = load(tiles_directory + "/" + file_name)
		file_name = dir.get_next()

	dir.list_dir_end()
