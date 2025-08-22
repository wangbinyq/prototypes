class_name Runner
extends Node3D

@export_range(0, 9e9) var start_speed_x := 5.0
@export_range(0, 9e9) var jump_acceleration := 100.0
@export_range(0, 9e9) var gravity := 40.0
@export_range(0, 9e9) var extents := 0.5

@export var jump_duration_min := 0.1
@export var jump_duration_max := 0.2

@onready var mesh := $Mesh as MeshInstance3D
@onready var point_light = $OmniLight3D
@onready var explosion := $"Explosion Particle" as GPUParticles3D
@onready var trail := $"Trail Particle" as GPUParticles3D

var pos := Vector2.ZERO
var velocity := Vector2.ZERO
var current_obstacle: SkylineObject
var grounded: bool
var transitioning: bool
var jump_time_remaining := 0.0

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
	transitioning = false
	grounded = true
	jump_time_remaining = 0
	velocity = Vector2(start_speed_x, 0)

func explode():
	mesh.hide()
	point_light.hide()
	trail.emitting = false
	position = Vector3(pos.x, pos.y, 0)
	explosion.restart()

func run(dt: float) -> bool:
	move(dt)
	if pos.x + extents < current_obstacle.max_x:
		constrain_y(current_obstacle)
	else:
		var still_inside_current = (pos.x - extents) < current_obstacle.max_x
		if still_inside_current:
			constrain_y(current_obstacle)

		if !transitioning:
			if check_collision():
				return false
			transitioning = true

		constrain_y(current_obstacle.next)
		if !still_inside_current:
			current_obstacle = current_obstacle.next
			transitioning = false
	return true

func update_visualization():
	position = Vector3(pos.x, pos.y, 0)

func constrain_y(obstacle: SkylineObject):
	var open_y = obstacle.gap_y
	if pos.y - extents <= open_y.min:
		pos.y = open_y.min + extents
		velocity.y = maxf(velocity.y, 0)
		jump_time_remaining = 0
		grounded = true
	elif pos.y + extents >= open_y.max:
		pos.y = open_y.max - extents
		velocity.y = minf(velocity.y, 0)
		jump_time_remaining = 0

func check_collision():
	var tp := Vector2.ZERO
	tp.x = current_obstacle.max_x - extents
	tp.y = pos.y - velocity.y * (pos.x - tp.x) / velocity.x
	var shrunk = extents - 0.01
	var gap_y = current_obstacle.next.gap_y
	if tp.y - shrunk < gap_y.min or tp.y + shrunk > gap_y.max:
		pos = tp
		explode()
		return true
	return false

func move(dt: float):
	pos += velocity * dt
	if jump_time_remaining > 0:
		jump_time_remaining -= dt
		velocity.y += jump_acceleration * minf(dt, jump_time_remaining)
	else:
		velocity.y -= gravity * dt
	grounded = false
	pos += velocity * dt

func start_jumping():
	if grounded:
		jump_time_remaining = jump_duration_max

func end_jumping():
	jump_time_remaining += jump_duration_min - jump_duration_max
