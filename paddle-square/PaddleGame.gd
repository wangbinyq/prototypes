extends Node3D

@export var ball: Ball
@export var top_paddle: Paddle
@export var bottom_paddle: Paddle
@export var arena_extents := Vector2(10, 10)

func _ready():
	ball.start_new_game()

func _process(delta: float):
	top_paddle.move(ball.pos.x, arena_extents.x, delta)
	bottom_paddle.move(ball.pos.y, arena_extents.y, delta)
	ball.move(delta)
	bouncey_if_needed()
	bouncex_if_needed(ball.pos.x)
	ball.update_visualization()

func bouncey_if_needed():
	var y_extents = arena_extents.y - ball.extents

	if ball.pos.y < -y_extents:
		bounce_y(-y_extents, bottom_paddle)
	elif ball.pos.y > y_extents:
		bounce_y(y_extents, top_paddle)

func bounce_y(boundary: float, paddle: Paddle):
	var duration_after_bounce = (ball.pos.y - boundary) / ball.velocity.y
	var bounce_x = ball.pos.x - ball.velocity.x * duration_after_bounce

	bouncex_if_needed(bounce_x)
	bounce_x = ball.pos.x - ball.velocity.x * duration_after_bounce
	ball.bounce_y(boundary)
	var hit = paddle.hit_ball(bounce_x, ball.extents)
	if hit.hit:
		ball.set_x_position_and_speed(bounce_x, hit.hit_factor, duration_after_bounce)

func bouncex_if_needed(x: float):
	var x_extents = arena_extents.x - ball.extents

	if x < -x_extents:
		ball.bounce_x(-x_extents)
	elif x > x_extents:
		ball.bounce_x(x_extents)
