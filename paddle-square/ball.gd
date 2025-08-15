class_name Ball
extends MeshInstance3D

@export_range(0, 100) var x_speed: float = 8.0
@export_range(0, 100) var y_speed: float = 10.0
@export_range(0, 100) var extents: float = 0.5

var pos: Vector2
var velocity: Vector2

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
    velocity = Vector2(x_speed, y_speed)