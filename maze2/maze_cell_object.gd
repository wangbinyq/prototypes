class_name MazeCellObject
extends MeshInstance3D

func _ready() -> void:
	var m = mesh.surface_get_material(0)
	m.cull_mode = BaseMaterial3D.CULL_DISABLED
