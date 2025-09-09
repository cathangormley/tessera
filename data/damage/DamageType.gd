extends Resource
class_name DamageType

enum Type {
	UNTYPED,
	PHYSICAL,
	ELEMENTAL,
}

enum Subtype {
	UNTYPED,
	# Physical damage types
	PIERCING,
	SLASHING,
	BLUDGEONING,
	# Elemental damage types
	FIRE,
	WATER,
	ELECTRIC,
	WIND,
	LIGHT,
	DARK,
}

@export var type: Type
@export var subtype: Subtype
