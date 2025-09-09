## Effect representing dealing damage to units in the target area
extends Effect
class_name EffectHitForDamage

@export var min_damage: int
@export var max_damage: int

@export var hit: int

@export var scaling_attributes: Dictionary[AttributeArray.Attribute, float]

@export var damage_type: DamageType = preload("res://data/damage/physical/damage_bludgeoning.tres")

var ev_damage: float:
	get():
		# TODO! Add attribute scaling
		return (hit / 100.0) * (min_damage + max_damage) / 2.0


## Deal damage to all units in the target area
func execute(user: Unit, target_area: CellArea):
	print(user.unit_name + " deals damage.")
	var target_units = target_area.get_units()
	for target_unit in target_units:
		hit_unit(user, target_unit)


func hit_unit(user: Unit, target_unit: Unit):
	var is_hit := try_to_hit(hit, user, target_unit)
	if not is_hit:
		print(target_unit.unit_name + " dodges")
		show_miss_splash(target_unit)
		return
	# if is_hit:
	var damage := calculate_damage(user, target_unit, min_damage, max_damage, scaling_attributes, damage_type)

	print(target_unit.unit_name + " takes " + str(damage) + " damage.")
	show_damage_splash(target_unit, damage)
	target_unit.take_damage(damage)
