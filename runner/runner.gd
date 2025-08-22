class_name Runner
extends Node3D

@export_range(0, 9e9) var start_speed_x := 5.0

@onready var mesh := $Mesh as MeshInstance3D
@onready var point_light = $OmniLight3D
@onready var explosion := $"Explosion Particle" as GPUParticles3D
@onready var trail := $"Trail Particle" as GPUParticles3D

var pos := Vector2.ZERO

func _ready() -> void:
	mesh.hide()
	point_light.hide()
	trail.emitting = false

func start_new_game():
	pos = Vector2.ZERO
	position = Vector3.ZERO
	mesh.show()
	point_light.show()
	trail.emitting = true

func explode():
	mesh.hide()
	point_light.hide()
	trail.emitting = false
	position = Vector3(pos.x, pos.y, 0)
	explosion.restart()

func run(dt: float) -> bool:
	if pos.x > 12:
		explode()
		return false
	pos.x += start_speed_x * dt
	return true

func update_visualization():
	position = Vector3(pos.x, pos.y, 0)

func _process(delta: float) -> void:
	pass
