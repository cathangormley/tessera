## Represents a body type
extends Resource
class_name Body

enum ArmorSlot { HEAD, CHEST, ARMS, LEGS, }

@export var armor_slots: Array[ArmorSlot]
