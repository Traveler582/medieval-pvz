extends Node2D

const ROWS = 7
const COLS = 7
const CELL_SIZE = 90

var grid_origin = Vector2(200,9)

func _draw():
	for row in ROWS:
		for col in COLS:
			var rect = Rect2(
				grid_origin + Vector2(col * CELL_SIZE, row * CELL_SIZE),
				Vector2(CELL_SIZE,CELL_SIZE)
			)
			draw_rect(rect, Color.WHITE, false)
