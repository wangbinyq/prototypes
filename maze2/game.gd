class_name MazeGame
extends Node3D

@export var maze_size := Vector2i(20, 20)
@onready var visualization := $MazeVisualization

var maze: Maze
func _ready() -> void:
	maze = Maze.new(maze_size)
	visualization.visualize(maze)
