extends Node2D

const ROWS = 7
const COLS = 7
const CELL_SIZE = 90

var grid_origin = Vector2(200,9)
var hovered_cell = Vector2i(-1,-1)
var selected_cell = Vector2i(-1, -1)
var occupied_cells: Dictionary = {}
signal cell_selected(cell: Vector2i)

func _draw():
	for row in ROWS:
		for col in COLS:
			var rect = Rect2(
				grid_origin + Vector2(col * CELL_SIZE, row * CELL_SIZE),
				Vector2(CELL_SIZE,CELL_SIZE)
			)
			draw_rect(rect, Color.WHITE, false)
			if Vector2i(col,row) == hovered_cell:
				draw_rect(rect, Color(1, 1, 0, 0.3), true)
			if Vector2i(col, row) == selected_cell:
				draw_rect(rect, Color(0, 1, 0, 0.3), true)
func _process(_delta):
	var mouse_pos = get_local_mouse_position()
	var cell = world_to_grid(mouse_pos)
	if is_valid_cell(cell):
		if cell != hovered_cell:
			hovered_cell = cell
			queue_redraw()
	else:
		if hovered_cell != Vector2i(-1,-1):
			hovered_cell = Vector2i(-1, -1)
			queue_redraw()

func world_to_grid(pos: Vector2) -> Vector2i:
	var relative = pos - grid_origin
	return Vector2i(int(floor(relative.x / CELL_SIZE)), int(floor(relative.y / CELL_SIZE)))

func grid_to_world(cell: Vector2i) -> Vector2:
	return grid_origin + Vector2(cell.x * CELL_SIZE + CELL_SIZE/2, cell.y * CELL_SIZE + CELL_SIZE / 2)

func is_valid_cell(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < COLS and cell.y >= 0 and cell.y < ROWS

func is_cell_occupied(cell: Vector2i) -> bool:
	return occupied_cells.has(cell)

func occupy_cell(cell: Vector2i, unit: Node) -> void:
	occupied_cells[cell] = unit

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var cell = world_to_grid(get_local_mouse_position())
			if is_valid_cell(cell):
				selected_cell = cell
				queue_redraw()
				emit_signal("cell_selected", cell)
