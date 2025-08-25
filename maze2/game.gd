class_name MazeGame
extends Node3D

@export var pick_last_probability := 0.5
@export var open_dead_end_probability := 0.5
@export var open_arbitrary_probability := 0.5
@export var maze_size := Vector2i(20, 20)
@onready var visualization := $MazeVisualization
@onready var maze: Maze
@onready var player := $Player as MazePlayer

func _ready() -> void:
	maze = Maze.new(maze_size)
	maze.generate(pick_last_probability)
	maze.open_dead_ends(open_dead_end_probability)
	maze.open_arbitrary_passages(open_arbitrary_probability)
	visualization.clear()
	visualization.visualize(maze)

func _on_reset_pressed() -> void:
	_ready()
