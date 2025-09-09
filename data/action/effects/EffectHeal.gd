## Effect representing dealing damage to units in the target area
extends Effect
class_name EffectHeal

@export var min_heal: int
@export var max_heal: int

var ev_heal: float:
	get():
		return (min_heal + max_heal) / 2.0


## Deal damage to all units in the target area
func execute(user: Unit, target_area: CellArea):
	print(user.unit_name + " heals.")
	var target_units = target_area.get_units()
	for target_unit in target_units:
		var heal = randi_range(min_heal, max_heal)
		print(target_unit.unit_name + " heals " + str(heal) + " damage.")
		show_damage_splash(target_unit, heal)
		target_unit.heal_damage(heal)
