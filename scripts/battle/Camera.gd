extends Camera2D
class_name CameraGrid

## The speed the camera moves when manually panned
@export var manual_pan_speed: float = 3.0
## THe speed the camera moves when a cell is focussed
@export var focus_pan_speed: float = 7.0

var map_bounds: Rect2

func _process(_delta: float) -> void:
	var move_dir = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up"):
		move_dir.y -= 1
	if Input.is_action_pressed("ui_down"):
		move_dir.y += 1
	if Input.is_action_pressed("ui_left"):
		move_dir.x -= 1
	if Input.is_action_pressed("ui_right"):
		move_dir.x += 1
	
	
	move_dir = move_dir.normalized()
	var d = round(move_dir * manual_pan_speed)
	position = clamp_to_bounds(d + position)
	
	if Input.is_action_pressed("ui_text_delete"):
		focus_on_cell(get_parent().grid[10][10])


func focus_on_cell(cell: Cell) -> void:
	position = clamp_to_bounds(cell.position)
	

## TODO! Fix this
func clamp_to_bounds(pos: Vector2) -> Vector2:
	return pos
	# Half the viewport size (so camera edges don’t go out of bounds)
	var half_screen = get_viewport_rect().size / 100 # / 2
	var min_x = map_bounds.position.x + half_screen.x
	var max_x = map_bounds.position.x + map_bounds.size.x - half_screen.x
	var min_y = map_bounds.position.y + half_screen.y
	var max_y = map_bounds.position.y + map_bounds.size.y - half_screen.y

	return Vector2(
		clamp(pos.x, min_x, max_x),
		clamp(pos.y, min_y, max_y)
	)
