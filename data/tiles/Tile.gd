# Tile.gd
extends Resource
class_name Tile

const MAX_COST: int = 65536

@export var name: String
@export var walkable: bool
@export var walking_cost: int = MAX_COST
@export var flying_cost: int = 1
@export var color: Color

@export var dodge: int
