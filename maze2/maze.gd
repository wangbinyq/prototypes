class_name Maze
extends Node

var size: Vector2i
var length: int:
	get:
		return size.x * size.y
var cells: Array[int] = []
	
func _init(s: Vector2i) -> void:
	size = s

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

func get_cell(i: int) -> int:
	return cells[i]

func set_cell(i: int, v: int) -> void:
	cells[i] = v

func set_cell_with(i: int, mask: int) -> void:
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
