extends Node3D

@export var ball: Ball
@export var top_paddle: Paddle
@export var bottom_paddle: Paddle
@export var arena_extents := Vector2(10, 10)
@export_range(2, 100) var points_to_win := 3
@export var countdown_text: Label3D
@export_range(1, 100) var new_game_delay := 3.0
@export var lively_camera: LivelyCamera

var countdown_until_new_game := 0.0

func _ready():
	countdown_until_new_game = new_game_delay

func start_new_game():
	ball.start_new_game()
	top_paddle.start_new_game()
	bottom_paddle.start_new_game()

func _process(delta: float):
	top_paddle.move(ball.pos.x, arena_extents.x, delta)
	bottom_paddle.move(ball.pos.y, arena_extents.y, delta)
	if countdown_until_new_game <= 0:
		update_game(delta)
	else:
		update_countdown(delta)


func update_game(delta: float):
	ball.move(delta)
	bouncey_if_needed()
	bouncex_if_needed(ball.pos.x)
	ball.update_visualization()

func update_countdown(delta: float):
	countdown_until_new_game -= delta
	if countdown_until_new_game <= 0.0:
		countdown_text.hide()
		start_new_game()
	else:
		var display_value = int(countdown_until_new_game)
		if display_value < new_game_delay:
			countdown_text.text = str(display_value)

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
	lively_camera.push_xy(ball.velocity)
	ball.bounce_y(boundary)
	var hit = defender.hit_ball(bounce_x, ball.extents)
	if hit.hit:
		ball.set_x_position_and_speed(bounce_x, hit.hit_factor, duration_after_bounce)
	else:
		lively_camera.jostle_y()
		if attacker.score_point(points_to_win):
			end_game()

func bouncex_if_needed(x: float):
	var x_extents = arena_extents.x - ball.extents

	if x < -x_extents:
		lively_camera.push_xy(ball.velocity)
		ball.bounce_x(-x_extents)
	elif x > x_extents:
		lively_camera.push_xy(ball.velocity)
		ball.bounce_x(x_extents)

func end_game():
	countdown_until_new_game = new_game_delay
	countdown_text.set_text('GAME OVER')
	countdown_text.show()
	ball.end_game()
