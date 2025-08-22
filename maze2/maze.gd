class_name Maze
extends Object

var size: Vector2i
var length: int:
	get:
		return size.x * size.y
	
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
