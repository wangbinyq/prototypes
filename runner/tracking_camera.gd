class_name TrackingCamera
extends Camera3D

@export var y_curve: Curve

@onready var offset := position
var view_factor_x: float

func _ready() -> void:
	var vp = get_viewport()
	var c = vp.get_camera_3d()
	view_factor_x = tan(deg_to_rad(c.fov * 0.5)) * vp.size.x / vp.size.y

func start_new_game():
	track(Vector3.ZERO)

func track(focus_point: Vector3):
	position = focus_point + offset
	position.y = y_curve.sample(position.y)

func visible_x(z: float):
	return FloatRange.position_extents(position.x, view_factor_x * (position.z - z))
