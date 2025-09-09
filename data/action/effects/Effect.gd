## Represents any kind of effect that an action may have
## In general, actions result in several effects happening in a specified order
extends Resource
class_name Effect

# Animation stuff?

## Perform the effect as user on the target area specified
func execute(_user: Unit, _target_area: CellArea) -> void:
	assert(false, "This method must be overridden")


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


func try_to_hit(hit: int, user: Unit, target_unit: Unit) -> bool:
	var chance = hit + user.stats.hit - target_unit.stats.dodge
	return Utils.roll_percentage(chance)


func calculate_damage(user: Unit, target_unit: Unit, min_damage: int, max_damage: int,
		scaling_attributes: Dictionary[AttributeArray.Attribute, float], damage_type: DamageType) -> int:
	var damage := randi_range(min_damage, max_damage)
	# Add e.g. unit's strength to damage
	for attr in scaling_attributes:
		damage += int(scaling_attributes[attr] * user.stats.attributes.get_attr(attr))
	# TODO! Defense of target unit
	match damage_type.type:
		DamageType.Type.PHYSICAL: damage -= target_unit.stats.physical_defense
		DamageType.Type.ELEMENTAL: damage -= target_unit.stats.elemental_defense

	if damage < 0: damage = 0
	return damage
