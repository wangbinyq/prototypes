extends Node3D

@export var ball: Ball
@export var top_paddle: Paddle
@export var bottom_paddle: Paddle
@export var arena_extents := Vector2(10, 10)
@export_range(2, 100) var points_to_win := 3

func _ready():
	start_new_game()

func start_new_game():
	ball.start_new_game()
	top_paddle.start_new_game()
	bottom_paddle.start_new_game()

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
		bounce_y(-y_extents, bottom_paddle, top_paddle)
	elif ball.pos.y > y_extents:
		bounce_y(y_extents, top_paddle, bottom_paddle)

func bounce_y(boundary: float, defender: Paddle, attacker: Paddle):
	var duration_after_bounce = (ball.pos.y - boundary) / ball.velocity.y
	var bounce_x = ball.pos.x - ball.velocity.x * duration_after_bounce

	bouncex_if_needed(bounce_x)
	bounce_x = ball.pos.x - ball.velocity.x * duration_after_bounce
	ball.bounce_y(boundary)
	var hit = defender.hit_ball(bounce_x, ball.extents)
	if hit.hit:
		ball.set_x_position_and_speed(bounce_x, hit.hit_factor, duration_after_bounce)
	elif attacker.score_point(points_to_win):
		start_new_game()

func bouncex_if_needed(x: float):
	var x_extents = arena_extents.x - ball.extents

	if x < -x_extents:
		ball.bounce_x(-x_extents)
	elif x > x_extents:
		ball.bounce_x(x_extents)
