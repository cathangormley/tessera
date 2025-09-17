## Represents any kind of effect that an action may have
## In general, actions result in several effects happening in a specified order
extends Resource
class_name Effect

# Animation stuff?

## Perform the effect as user on the target area specified
func execute(_user: Unit, _target_area: CellArea) -> void:
	pass


## Shows a forecast of what the effect will do
func get_forecast(user: Unit) -> String:
	return ""


## Show a splash over the cell displaying text
func show_splash(cell: Cell, text: String) -> void:
	var splash_scene = preload("res://scenes/ui/damage_splash/damage_splash.tscn")
	var splash = splash_scene.instantiate()

	cell.add_child(splash)
	splash.show_damage(text)


func show_damage_splash(unit: Unit, damage: int) -> void:
	show_splash(unit.cell, str(damage))


func show_miss_splash(unit: Unit) -> void:
	show_splash(unit.cell, "MISS")
