class_name SlowdownObject
extends Node3D

@export var item: Node3D
@export var explosion_particle: GPUParticles3D
@export var radius := 1.0
@export var speed_factor := 0.75
@export var spawn_probability := 0.5

func check(runner: Runner):
	if item.is_visible_in_tree() and (item.global_position - runner.global_position).length_squared() < radius * radius:
		item.hide()
		explosion_particle.restart()
		runner.speed_x *= speed_factor

func _enter_tree() -> void:
	if randf() < spawn_probability:
		item.show()
	else:
		item.hide()
