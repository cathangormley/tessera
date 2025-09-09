extends Node2D

@onready var label: Label = %Label
@onready var anim: AnimationPlayer = %AnimationPlayer

func show_damage(damage: Variant) -> void:
	label.text = str(damage)
	anim.play("float_up")
