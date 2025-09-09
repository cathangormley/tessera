extends Node2D
class_name ActionSubmenu

signal action_button_hovered(action: Action)
signal action_button_pressed(action: Action)
signal cancel_pressed()

@onready var actions_vbox := %VBoxContainer

func display_actions(actions) -> void:
	
	for action in actions:
		var button = Button.new()
		button.text = "%s (%d)" % [action.name, action.sp_cost]
		button.tooltip_text = action.description
		button.pressed.connect(_on_action_button_pressed.bind(action))
		button.mouse_entered.connect(_on_action_button_hovered.bind(action))
		button.mouse_exited.connect(_on_action_button_hovered.bind(null))
		actions_vbox.add_child(button)
	
	# Keep cancel at the bottom
	actions_vbox.move_child(%Cancel, -1)


func _on_action_button_hovered(action: Action) -> void:
	action_button_hovered.emit(action)


func _on_action_button_pressed(action: Action) -> void:
	action_button_pressed.emit(action)


func _on_cancel_pressed() -> void:
	cancel_pressed.emit()
