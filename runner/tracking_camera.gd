class_name TrackingCamera
extends Camera3D

@onready var offset = position

func start_new_game():
	track(Vector3.ZERO)

func track(focus_point: Vector3):
	position = focus_point + offset