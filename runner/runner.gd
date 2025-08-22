class_name Runner
extends Node3D

@export_range(0, 9e9) var start_speed_x := 5.0
@export_range(0, 9e9) var extents := 0.5

@onready var mesh := $Mesh as MeshInstance3D
@onready var point_light = $OmniLight3D
@onready var explosion := $"Explosion Particle" as GPUParticles3D
@onready var trail := $"Trail Particle" as GPUParticles3D

var pos := Vector2.ZERO
var current_obstacle: SkylineObject

func _ready() -> void:
	mesh.hide()
	point_light.hide()
	trail.emitting = false

func start_new_game(obstacle: SkylineObject):
	current_obstacle = obstacle
	while current_obstacle.max_x < extents:
		current_obstacle = current_obstacle.next
	pos = Vector2(0, current_obstacle.gap_y.min + extents)
	position = Vector3(pos.x, pos.y, 0)
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
	if pos.x > 1e9:
		explode()
		return false
	pos.x += start_speed_x * dt
	return true

func update_visualization():
	position = Vector3(pos.x, pos.y, 0)

func _process(delta: float) -> void:
	pass
