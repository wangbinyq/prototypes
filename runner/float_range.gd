class_name FloatRange

var min: float
var max: float
var rand: float:
	get:
		return randf_range(min, max)

func _init(mi: float, ma: float) -> void:
	min = mi
	max = ma

func grow_extents(extents: float):
	return FloatRange.new(
		min - extents,
		max + extents
	)

func shift(s: float):
	return FloatRange.new(min + s, max + s)

func _to_string() -> String:
	return "FloatRange(%f, %f)" % [min, max]

static func position_extents(position: float, extents: float):
	return FloatRange.new(position - extents, position + extents)
