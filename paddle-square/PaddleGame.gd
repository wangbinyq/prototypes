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
	bouncex_if_needed()
	ball.update_visualization()

func bouncey_if_needed():
	var y_extents = arena_extents.y - ball.extents

	if ball.pos.y < -y_extents:
		ball.bounce_y(-y_extents)
	elif ball.pos.y > y_extents:
		ball.bounce_y(y_extents)

func bouncex_if_needed():
	var x_extents = arena_extents.x - ball.extents

	if ball.pos.x < -x_extents:
		ball.bounce_x(-x_extents)
	elif ball.pos.x > x_extents:
		ball.bounce_x(x_extents)
