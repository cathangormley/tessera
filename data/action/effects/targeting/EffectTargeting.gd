## Class representing all effect that apply to units individually
extends Effect
class_name EffectTargeting

## Try to hit all units in the target area
func execute(user: Unit, target_area: CellArea):
	var target_units = target_area.get_units()
	for target_unit in target_units:
		effect_on_target(user, target_unit)


## The effect on each target
func effect_on_target(user: Unit, target_unit: Unit):
	pass
