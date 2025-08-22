class_name MazeGame
extends Node3D

@export var maze_size := Vector2i(20, 20)
@onready var visualization := $MazeVisualization
@onready var maze := Maze.new(maze_size)

func _ready() -> void:
	visualization.visualize(maze)
