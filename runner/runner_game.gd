extends Node3D

@export_range(0.001, 10) var max_delta_time := 1.0 / 120
@export var extra_gap_factor := 0.5
@export var extra_sequence_factor := 1

@onready var runner := $"Runner" as Runner
@onready var tracking_camera := $Camera3D as TrackingCamera
@onready var display_text := $UI/Label as Label
@onready var obstacle_generator := $"ObstacleGenerator" as SkylineGenerator
var skyline_generators: Array[SkylineGenerator] = []

var is_playing: bool

func _ready() -> void:
	for child in $SkylineGenerators.get_children():
		if child is SkylineGenerator:
			skyline_generators.append(child)

func start_new_game():
	tracking_camera.start_new_game()
	runner.start_new_game(obstacle_generator.start_new_game(tracking_camera))
	tracking_camera.track(runner.position)
	for generator in skyline_generators:
		generator.start_new_game(tracking_camera)
	is_playing = true

func _process(delta: float) -> void:
	if is_playing:
		update_game(delta)
	elif Input.is_action_just_pressed("ui_accept"):
		start_new_game()

func update_game(delta: float):
	if Input.is_action_just_pressed("ui_accept"):
		runner.start_jumping()
	elif Input.is_action_just_released("ui_accept"):
		runner.end_jumping()

	var accumulated_dt = delta
	while accumulated_dt > max_delta_time and is_playing:
		is_playing = runner.run(max_delta_time)
		accumulated_dt -= max_delta_time
	is_playing = is_playing and runner.run(accumulated_dt)
	runner.update_visualization()
	tracking_camera.track(runner.position)
	display_text.text = '%d' % floorf(runner.pos.x)

	obstacle_generator.fill_view(
		tracking_camera,
		extra_gap_factor * runner.speed_x,
		extra_sequence_factor * runner.speed_x
	)
	for generator in skyline_generators:
		generator.fill_view(tracking_camera)
