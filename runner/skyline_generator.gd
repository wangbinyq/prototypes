class_name SkylineGenerator
extends Node3D

@export var objects: Array[SkylineObject]
@export var distance: float
@export var altitude_min: float
@export var altitude_max: float

var altitude: FloatRange:
	get:
		return FloatRange.new(altitude_min, altitude_max)

const BORDER := 10.0
var end_position := Vector3.ZERO
var leftmost: SkylineObject
var rightmost: SkylineObject

func get_instance() -> SkylineObject:
	var instance = objects[randi_range(0, objects.size() - 1)].get_instance()
	add_child(instance)
	return instance

func fill_view(view: TrackingCamera):
	var visible_x = view.visible_x(distance).grow_extents(BORDER)

	while leftmost != rightmost and leftmost.max_x < visible_x.min:
		leftmost = leftmost.recycle()
	while end_position.x < visible_x.max:
		end_position.y = altitude.rand
		var next = get_instance()
		rightmost.next = next
		rightmost = next
		end_position = rightmost.place_after(end_position)

func start_new_game(view: TrackingCamera):
	while leftmost != null:
		leftmost = leftmost.recycle()
	var visible_x = view.visible_x(distance).grow_extents(BORDER)

	end_position = Vector3(visible_x.min, altitude.rand, distance)

	leftmost = get_instance()
	rightmost = leftmost
	print('x min', visible_x)
	print('end_position', end_position)
	end_position = rightmost.place_after(end_position)
	print('end_position', end_position)
	fill_view(view)
