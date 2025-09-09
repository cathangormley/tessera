## Displays the turn queue
extends Control
class_name TurnQueueHUD

signal unit_clicked(unit: Unit)

@export var max_display: int = 10   # how many upcoming turns to show
@export var viewport_size: Vector2i = Vector2i(32, 32)

@onready var queue_container: HBoxContainer = $QueueContainer

@export var turn_controller: TurnController = null


func update_queue_display() -> void:
	if turn_controller == null: return

	# Clear old
	for child in queue_container.get_children():
		child.queue_free()

	# Show first n units
	var count = min(max_display, turn_controller.turn_queue.size())
	for i in range(count):
		var event = turn_controller.turn_queue[i] as TurnController.TurnEvent
		var tex_rect = make_unit_icon(event)

		queue_container.add_child(tex_rect)



func make_unit_icon(event: TurnController.TurnEvent) -> TextureRect:
	
	# Create viewport
	var viewport := SubViewport.new()
	viewport.size = viewport_size
	viewport.transparent_bg = false
	viewport.render_target_update_mode = SubViewport.UPDATE_ONCE

	# Instance a clone of the unit's AnimatedSprite2D
	var sprite: AnimatedSprite2D = event.unit.get_node("AnimatedSprite2D").duplicate()
	# Center it in the viewport
	sprite.position = viewport_size / 2
	sprite.modulate = (event.unit.color + Color(1, 1, 1)) / 2.0
	viewport.add_child(sprite)

	# Wrap viewport into TextureRect
	var tex_rect := TextureRect.new()
	tex_rect.texture = viewport.get_texture()
	tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	tex_rect.custom_minimum_size = viewport_size
	
	# Connect hover events
	tex_rect.mouse_entered.connect(_on_mouse_entered.bind(event.unit))
	tex_rect.mouse_exited.connect(_on_mouse_exited.bind(event.unit))
	
	tex_rect.gui_input.connect(_on_icon_gui_input.bind(event.unit))
	
	tex_rect.tooltip_text = event.unit.unit_name + "\n" + ("%0.2f" % event.time) + "s"
	
	# Attach viewport as hidden child so it updates
	tex_rect.add_child(viewport)

	return tex_rect


func _on_mouse_entered(unit: Unit) -> void:
	print("Hovered over: " + unit.unit_name)
	unit.get_node("AnimatedSprite2D").modulate = Color(2, 2, 2)
	# TODO! emit signal


func _on_mouse_exited(unit: Unit) -> void:
	print("Stopped hovering: " + unit.unit_name)
	unit.get_node("AnimatedSprite2D").modulate = Color(1, 1, 1)
	# TODO! emit signal


func _on_icon_gui_input(event: InputEvent, unit: Unit) -> void:
	if event.is_action_pressed("ui_left_click"):
		unit_clicked.emit(unit)
