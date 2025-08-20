extends Camera3D

@onready var offset = position

func track(focus_point: Vector3):
	position = focus_point + offset