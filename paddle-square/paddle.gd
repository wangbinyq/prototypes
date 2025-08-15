class_name Paddle
extends MeshInstance3D

@export_range(0, 100) var extents := 4.0
@export_range(0, 100) var speed := 10.0

func move(target: float, arena_extents: float):
    var limit = arena_extents - extents
    position.x = clampf(position.x, -limit, limit)

func adjust_by_ai(x: float, target: float, delta: float):
    if x < target:
        return minf(x + speed * delta, target)
    return maxf(x - speed * delta, target)