class_name LivelyCamera

extends Camera3D

@export_range(0, 100) var spring_strength := 100.0
@export_range(0, 100) var damping_strength := 10.0
@export_range(0, 100) var jostle_strength := 40.0
@export_range(0, 100) var pushstrength := 1.0
@export_range(0, 1) var max_delta_time := 1.0 / 60.0

@onready var anchor_position := position
var velocity := Vector3.ZERO

func jostle_y():
    velocity.y += jostle_strength

func push_xy(impluse: Vector2):
    velocity.x += impluse.x * pushstrength
    velocity.y += impluse.y * pushstrength

func _process(delta: float) -> void:
    while (delta > max_delta_time):
        time_step(max_delta_time)
        delta -= max_delta_time
    time_step(delta)

func time_step(delta: float) -> void:
    var displacement = anchor_position - position
    var acceleration = displacement * spring_strength - velocity * damping_strength
    velocity += acceleration * delta
    position += velocity * delta
