class_name MazeVisualization
extends Node3D

@export var end: PackedScene
@export var straight: PackedScene
@export var corner: PackedScene
@export var t_junction: PackedScene
@export var x_junction: PackedScene

func visualize(maze: Maze):
	for i in range(maze.length):
		var instance = x_junction.instantiate()
		instance.global_position = maze.index_to_world_position(i)
		add_child(instance)
