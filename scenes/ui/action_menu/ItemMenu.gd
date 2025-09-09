extends Node2D
class_name ItemMenu

signal item_button_pressed(item: Item)
signal cancel_pressed()

@onready var items_vbox: VBoxContainer = %Items

func display_items(unit: Unit) -> void:
	# Items with any actions associated with them
	var action_items: Array[Item] = []
	
	for item in unit.inventory.items:
		if item.actions.size() > 0:
			action_items.append(item)
	
	for item in action_items:
		var button = Button.new()
		button.text = "%s: %d" % [item.item_name, item.actions.size()]
		button.tooltip_text = item.description
		button.pressed.connect(_on_button_pressed.bind(item))
		items_vbox.add_child(button)
	
	items_vbox.move_child(%Cancel, -1)


func _on_button_pressed(item: Item) -> void:
	item_button_pressed.emit(item)


func _on_cancel_pressed() -> void:
	cancel_pressed.emit()
