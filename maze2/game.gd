class_name MazeGame
extends Node3D

@export var pick_last_probability := 0.5
@export var maze_size := Vector2i(20, 20)
@onready var visualization := $MazeVisualization
@onready var maze: Maze

func _ready() -> void:
	maze = Maze.new(maze_size)
	maze.generate(pick_last_probability)
	visualization.visualize(maze)

func _on_reset_pressed() -> void:
	_ready()
