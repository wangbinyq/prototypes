class_name Paddle
extends MeshInstance3D

@export var is_ai := false
@export_range(0, 100) var extents := 4.0
@export_range(0, 100) var speed := 10.0

func move(target: float, arena_extents: float, delta: float):
    var px = adjust_by_ai(position.x, target, delta) if is_ai else adjust_by_player(position.x, delta)
    var limit = arena_extents - extents
    px = clampf(px, -limit, limit)
    position.x = px

func adjust_by_ai(x: float, target: float, delta: float):
    if x < target:
        return minf(x + speed * delta, target)
    return maxf(x - speed * delta, target)

func adjust_by_player(x: float, delta: float):
    var go = Input.get_axis("ui_left", "ui_right")
    if go != 0:
        return x + go * speed * delta
    return x
