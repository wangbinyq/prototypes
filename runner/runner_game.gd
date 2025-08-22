extends Node3D

@export_range(0.001, 10) var max_delta_time := 1.0 / 120

@onready var runner := $"Runner" as Runner
@onready var tracking_camera := $Camera3D as TrackingCamera
@onready var display_text := $UI/Label as Label


var is_playing: bool

func start_new_game():
	tracking_camera.start_new_game()
	runner.start_new_game()
	is_playing = true

func _process(delta: float) -> void:
	if is_playing:
		update_game(delta)
	elif Input.is_action_just_pressed("ui_accept"):
		start_new_game()

func update_game(delta: float):
	var accumulated_dt = delta
	while accumulated_dt > max_delta_time and is_playing:
		is_playing = runner.run(max_delta_time)
		accumulated_dt -= max_delta_time
	is_playing = is_playing and runner.run(accumulated_dt)
	runner.update_visualization()
	tracking_camera.track(runner.position)
	display_text.text = '%d' % floorf(runner.pos.x)
