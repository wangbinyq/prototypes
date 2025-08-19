class_name Grid

var rows: int
var columns: int
var cell_count: int:
	get:
		return rows * columns
var states: PackedInt32Array = PackedInt32Array()
var revealed_cell_count: int = 0
var hidden_cell_count: int:
	get:
		return cell_count - revealed_cell_count

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
	revealed_cell_count = 0
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

	var row_offset = 1 if c & 1 == 0 else -1
	increment(r + row_offset, c - 1)
	increment(r + row_offset, c + 1)

func increment(r: int, c: int) -> void:
	var i = try_get_cell_index(r, c)
	if i == -1:
		return
	states[i] += 1

func reveal(index: int) -> void:
	var row_column = get_row_column(index)
	var r = row_column[0]
	var c = row_column[1]
	var stack := Array()

	push_if_needed(stack, r, c)
	while stack.size() > 0:
		c = stack.pop_back()
		r = stack.pop_back()
		push_if_needed(stack, r - 1, c)
		push_if_needed(stack, r + 1, c)
		push_if_needed(stack, r, c - 1)
		push_if_needed(stack, r, c + 1)

		r += 1 if c & 1 == 0 else -1
		push_if_needed(stack, r, c - 1)
		push_if_needed(stack, r, c + 1)
		

func push_if_needed(stack: Array, r: int, c: int) -> void:
	var i = try_get_cell_index(r, c)
	if i == -1:
		return
	var state = states[i]
	if CellState.is_not(state, CellState.MARKED_OR_REVEALED):
		if state == CellState.ZERO:
			stack.append(r)
			stack.append(c)
		revealed_cell_count += 1
		states[i] = CellState.with(state, CellState.REVEALED)

func reveal_mines_and_mistakes() -> void:
	for i in range(cell_count):
		var state = states[i]
		states[i] = CellState.with(state, CellState.REVEALED if CellState.is_(state, CellState.MARKED_SURE_OR_MINE) else CellState.ZERO)
