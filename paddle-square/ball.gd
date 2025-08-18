class_name Ball
extends MeshInstance3D

@export_range(0, 100) var max_x_speed := 20.0
@export_range(0, 100) var max_start_x_speed := 2.0
@export_range(0, 100) var start_x_speed := 8.0
@export_range(0, 100) var constant_y_speed := 10.0
@export_range(0, 100) var extents := 0.5

var pos: Vector2
var velocity: Vector2

func _ready() -> void:
    hide()

func update_visualization():
    position = Vector3(pos.x, 0, -pos.y)

func move(delta: float):
    pos += velocity * delta

func bounce_x(boundary: float):
    pos.x = 2 * boundary - pos.x
    velocity.x = - velocity.x

func bounce_y(boundary: float):
    pos.y = 2 * boundary - pos.y
    velocity.y = - velocity.y

func start_new_game():
    pos = Vector2(0, 0)
    update_visualization()
    velocity.x = randf_range(-max_start_x_speed, max_start_x_speed)
    velocity.y = - constant_y_speed
    show()

func end_game():
    pos.x = 0
    hide()

func set_x_position_and_speed(start: float, speed_factor: float, delta: float):
    velocity.x = speed_factor * max_x_speed
    pos.x = start + velocity.x * delta