class_name Grid

var rows: int
var columns: int
var cell_count: int:
	get:
		return rows * columns
var states: PackedInt32Array = PackedInt32Array()
var revealed_cell_count: int = 0

func _init(r: int, c: int) -> void:
	self.rows = r
	self.columns = c
	states.resize(r * c)

func _destroy() -> void:
	states.clear()

func _get(property: StringName) -> int:
	var index = int(property)
	return states.get(index)

func get_cell_index(row: int, column: int) -> int:
	return row * columns + column

func try_get_cell_index(row: int, column: int) -> int:
	if row < 0 or row >= rows or column < 0 or column >= columns:
		return -1
	return get_cell_index(row, column)

func get_row_column(index: int) -> Array[int]:
	var r = index / columns
	var c = index - r * columns
	return [r, c]
