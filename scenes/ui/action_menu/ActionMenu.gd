## The action menu that is opened after the player has selected where
## the turn unit will move
extends Node2D
class_name ActionMenu

signal button_pressed(option: ButtonOption)
signal cancel_pressed()

enum ButtonOption { ITEM, JOB, RACE, SKILL, GENERAL, CANCEL, }


func _on_item_pressed() -> void:
	button_pressed.emit(ButtonOption.ITEM)


func _on_job_pressed() -> void:
	button_pressed.emit(ButtonOption.JOB)


func _on_race_pressed() -> void:
	button_pressed.emit(ButtonOption.RACE)


func _on_skill_pressed() -> void:
	button_pressed.emit(ButtonOption.SKILL)


func _on_general_pressed() -> void:
	button_pressed.emit(ButtonOption.GENERAL)


func _on_cancel_pressed() -> void:
	cancel_pressed.emit()
