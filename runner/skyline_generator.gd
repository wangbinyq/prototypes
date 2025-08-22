class_name SkylineGenerator
extends Node3D

@export var objects: Array[SkylineObject]
@export var distance: float
@export var altitude_min: float
@export var altitude_max: float

@export var gap_length_min: float
@export var gap_length_max: float
@export var sequence_length_min: float
@export var sequence_length_max: float
@export var gap_object: SkylineObject

@export var single_sequence_start: bool

@export_range(0, 10) var max_y_difference := 0.0

var altitude: FloatRange:
	get:
		return FloatRange.new(altitude_min, altitude_max)

var gap_length: FloatRange:
	get:
		return FloatRange.new(gap_length_min, gap_length_max)
var sequence_length: FloatRange:
	get:
		return FloatRange.new(sequence_length_min, sequence_length_max)

const BORDER := 10.0
var end_position := Vector3.ZERO
var leftmost: SkylineObject
var rightmost: SkylineObject
var sequence_end_x: float

func get_instance() -> SkylineObject:
	var instance = objects[randi_range(0, objects.size() - 1)].get_instance()
	add_child(instance)
	return instance

func fill_view(view: TrackingCamera, extra_gap_length := 0.0, extra_sequence_length := 0.0):
	var visible_x = view.visible_x(distance).grow_extents(BORDER)

	while leftmost != rightmost and leftmost.max_x < visible_x.min:
		leftmost = leftmost.recycle()
	while end_position.x < visible_x.max:
		if end_position.x > sequence_end_x:
			start_new_sequence(
				gap_length.rand + extra_gap_length,
				sequence_length.rand + extra_sequence_length
			)
		var next = get_instance()
		rightmost.next = next
		rightmost = next
		end_position = rightmost.place_after(end_position)

func start_new_game(view: TrackingCamera) -> SkylineObject:
	while leftmost != null:
		leftmost = leftmost.recycle()
	var visible_x = view.visible_x(distance).grow_extents(BORDER)
	sequence_end_x = visible_x.max if single_sequence_start else end_position.x + sequence_length.rand
	end_position = Vector3(visible_x.min, altitude.rand, distance)

	leftmost = get_instance()
	rightmost = leftmost
	end_position = rightmost.place_after(end_position)
	fill_view(view)
	return leftmost

func start_new_sequence(gap: float, sequence: float):
	if gap_object != null:
		var next = gap_object.get_instance()
		rightmost.next = next
		rightmost = next
		add_child(rightmost)
		rightmost.fill_gap(end_position, gap)
	end_position.x += gap
	sequence_end_x = end_position.x + sequence

	if max_y_difference > 0:
		end_position.y = randf_range(
			maxf(end_position.y - max_y_difference, altitude.min),
			minf(end_position.y + max_y_difference, altitude.max)
		)
	else:
		end_position.y = altitude.rand
