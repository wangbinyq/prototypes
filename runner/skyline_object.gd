class_name SkylineObject
extends Node3D

@export_range(1, 100) var extents: float
@export var gap_y_min: float
@export var gap_y_max: float

var gap_y: FloatRange:
	get:
		return FloatRange.new(gap_y_min, gap_y_max).shift(position.y)

var pool: Array[SkylineObject]
var next: SkylineObject
var max_x: float:
	get:
		return position.x + extents

func place_after(pos: Vector3) -> Vector3:
	pos.x += extents
	position = pos
	pos.x += extents
	return pos

func get_instance() -> SkylineObject:
	var instance: SkylineObject = null
	if pool == null:
		pool = []
	if pool.size() > 0:
		instance = pool.pop_front()
		instance.show()
	else:
		instance = self.duplicate()
		instance.pool = pool
	return instance

func recycle() -> SkylineObject:
	pool.push_back(self)
	hide()
	var n = next;
	next = null
	return n

func fill_gap(pos: Vector3, gap: float):
	extents = gap * 0.5
	pos.x += extents
	position = pos