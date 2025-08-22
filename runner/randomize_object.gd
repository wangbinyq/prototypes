class_name RandomizeObject
extends Node3D

@export var items: Array[Node3D]
@export var spawn_probability := 0.5

func _enter_tree() -> void:
	for item in items:
		if randf() < spawn_probability:
			item.show()
		else:
			item.hide()