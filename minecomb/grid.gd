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

func _set(property: StringName, value: Variant) -> bool:
	var index = int(property)
	states.set(index, int(value))
	return true

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

func place_mines(mines: int) -> void:
	var candidate_count = cell_count
	var candidates = PackedInt32Array()
	candidates.resize(candidate_count)
	for i in range(cell_count):
		states[i] = CellState.ZERO
		candidates[i] = i
	
	var rand = RandomNumberGenerator.new()
	for i in range(mines):
		var index = rand.randi_range(0, candidate_count - 1)
		candidate_count -= 1;
		set_mine(candidates[index])
		candidates[index] = candidates[candidate_count - 1]

func set_mine(index: int) -> void:
	states[index] = CellState.with(states[index], CellState.MINE)
	var row_column = get_row_column(index)
	var r = row_column[0]
	var c = row_column[1]
	increment(r - 1, c)
	increment(r + 1, c)
	increment(r, c - 1)
	increment(r, c + 1)

	var row_offset = 1 if (c & 1) == 0 else -1
	increment(r + row_offset, c - 1)
	increment(r + row_offset, c + 1)

func increment(r: int, c: int) -> void:
	var i = try_get_cell_index(r, c)
	if i == -1:
		return
	states[i] += 1
