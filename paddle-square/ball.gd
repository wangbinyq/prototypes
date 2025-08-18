class_name Ball
extends MeshInstance3D

@export_range(0, 100) var max_x_speed := 20.0
@export_range(0, 100) var max_start_x_speed := 2.0
@export_range(0, 100) var start_x_speed := 8.0
@export_range(0, 100) var constant_y_speed := 10.0
@export_range(0, 100) var extents := 0.5
@export var bounce_particle: GPUParticles3D
@export var bounce_particle_emission := 20
@export var start_particle: GPUParticles3D
@export var start_particle_emission := 100
@export var trail_particle: GPUParticles3D

var pos: Vector2
var velocity: Vector2

func _ready() -> void:
	hide()

func update_visualization():
	position = Vector3(pos.x, 0, -pos.y)
	trail_particle.position = Vector3(pos.x, 0, -pos.y)

func move(delta: float):
	pos += velocity * delta

func bounce_x(boundary: float):
	var duration = (pos.x - boundary) / (velocity.x)
	pos.x = 2 * boundary - pos.x
	velocity.x = - velocity.x
	emit_bounce_particle(boundary, pos.y - velocity.y * duration, 90 if boundary < 0 else 270)

func bounce_y(boundary: float):
	var duration = (pos.y - boundary) / (velocity.y)
	pos.y = 2 * boundary - pos.y
	velocity.y = - velocity.y
	emit_bounce_particle(pos.x - velocity.x * duration, boundary, 0 if boundary < 0 else 180)

func start_new_game():
	pos = Vector2(0, 0)
	update_visualization()
	velocity.x = randf_range(-max_start_x_speed, max_start_x_speed)
	velocity.y = - constant_y_speed
	show()
	start_particle.amount = start_particle_emission
	start_particle.restart()
	set_trail_emission(true)

func end_game():
	pos.x = 0
	hide()
	set_trail_emission(false)

func set_x_position_and_speed(start: float, speed_factor: float, delta: float):
	velocity.x = speed_factor * max_x_speed
	pos.x = start + velocity.x * delta

func emit_bounce_particle(x: float, y: float, r: float):
	bounce_particle.position = Vector3(x, 0, -y)
	bounce_particle.rotation = Vector3(0, 0, r)
	bounce_particle.amount = bounce_particle_emission
	bounce_particle.restart()

func set_trail_emission(enabled: bool):
	trail_particle.emitting = enabled
