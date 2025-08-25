class_name Maze
extends Node

var size: Vector2i
var length: int:
	get:
		return size.x * size.y
var cells: Array[int]
	
func _init(s: Vector2i) -> void:
	size = s
	cells = []
	for i in range(length):
		cells.append(MazeFlags.Empty)

func index_to_coordinates(index: int) -> Vector2i:
	var y = index / size.x
	var x = index - size.x * y
	return Vector2i(x, y)

func coordinates_to_world_position(coordinates: Vector2i, y := 0.0) -> Vector3:
	return Vector3(
		2.0 * coordinates.x + 1 - size.x,
		y,
		- (2.0 * coordinates.y + 1 - size.y)
	)

func index_to_world_position(index: int, y := 0.0) -> Vector3:
	return coordinates_to_world_position(index_to_coordinates(index), y)

func set_cell(i: int, mask: int) -> void:
	cells[i] = MazeFlags.with(cells[i], mask)

func unset_cell(i: int, mask: int) -> void:
	cells[i] = MazeFlags.without(cells[i], mask)

var size_ew: int:
	get:
		return size.x

var size_ns: int:
	get:
		return size.y

var step_n: int:
	get:
		return size.x

var step_e: int:
	get:
		return 1
	
var step_s: int:
	get:
		return -size.x

var step_w: int:
	get:
		return -1

func find_available_passages(index: int) -> Array[Vector3i]:
	var scratchpad: Array[Vector3i] = []
	var coordinates = index_to_coordinates(index)
	if coordinates.x + 1 < size_ew:
		var i = index + step_e
		if cells[i] == MazeFlags.Empty:
			scratchpad.append(Vector3i(i, MazeFlags.PassageE, MazeFlags.PassageW))
	if coordinates.x > 0:
		var i = index + step_w
		if cells[i] == MazeFlags.Empty:
			scratchpad.append(Vector3i(i, MazeFlags.PassageW, MazeFlags.PassageE))
	if coordinates.y + 1 < size_ns:
		var i = index + step_n
		if cells[i] == MazeFlags.Empty:
			scratchpad.append(Vector3i(i, MazeFlags.PassageN, MazeFlags.PassageS))
	if coordinates.y > 0:
		var i = index + step_s
		if cells[i] == MazeFlags.Empty:
			scratchpad.append(Vector3i(i, MazeFlags.PassageS, MazeFlags.PassageN))
	return scratchpad

func find_closed_passages(index: int, exclude: int) -> Array[Vector3i]:
	var coordinates = index_to_coordinates(index)
	var scratchpad: Array[Vector3i] = []
	if exclude != MazeFlags.PassageE and coordinates.x + 1 < size_ew:
		scratchpad.append(Vector3i(step_e, MazeFlags.PassageE, MazeFlags.PassageW))
	if exclude != MazeFlags.PassageW and coordinates.x > 0:
		scratchpad.append(Vector3i(step_w, MazeFlags.PassageW, MazeFlags.PassageE))
	if exclude != MazeFlags.PassageN and coordinates.y + 1 < size_ns:
		scratchpad.append(Vector3i(step_n, MazeFlags.PassageN, MazeFlags.PassageS))
	if exclude != MazeFlags.PassageS and coordinates.y > 0:
		scratchpad.append(Vector3i(step_s, MazeFlags.PassageS, MazeFlags.PassageN))
	return scratchpad

func generate(pick_last_probability: float) -> void:
	var active_indices = PackedInt32Array()
	active_indices.resize(length)
	var first_active_index = 0
	var last_active_index = 0
	active_indices[first_active_index] = randi_range(0, length - 1)
	while first_active_index <= last_active_index and last_active_index < length:
		var pick_last = randf() < pick_last_probability
		var random_active_index: int
		var index: int
		if pick_last:
			random_active_index = 0
			index = active_indices[last_active_index]
		else:
			random_active_index = randi_range(first_active_index, last_active_index)
			index = active_indices[random_active_index]
		var scratchpad = find_available_passages(index)
		var available_passage_count = scratchpad.size()
		if available_passage_count <= 1:
			active_indices[random_active_index] = active_indices[first_active_index]
			first_active_index += 1
		if available_passage_count > 0:
			var passage = scratchpad[randi_range(0, available_passage_count - 1)]
			set_cell(index, passage.y)
			cells[passage.x] = passage.z
			last_active_index += 1
			active_indices[last_active_index] = passage.x

func open_dead_ends(open_dead_end_probability: float) -> void:
	if open_dead_end_probability <= 0:
		return
	for i in range(length):
		var cell = cells[i]
		if MazeFlags.has_exactly_one(cell) and randf() < open_dead_end_probability:
			var scratchpad = find_closed_passages(i, cell)
			var passage = scratchpad[randi_range(0, scratchpad.size() - 1)]
			cells[i] = MazeFlags.with(cell, passage.y)
			set_cell(i + passage.x, passage.z)
