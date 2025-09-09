extends Unit
class_name PlayerUnit


func add_unit_data(_unit_name: String) -> void:
	super.new_unit(_unit_name)
	is_player_controlled = true
	faction = Unit.Faction.PLAYER
	color = Color("Blue")


@onready var action_menu_container: Node2D = %ActionMenuContainer
