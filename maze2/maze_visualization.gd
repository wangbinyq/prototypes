class_name MazeVisualization
extends Node3D

@export var dead_end: PackedScene
@export var straight: PackedScene
@export var corner: PackedScene
@export var t_junction: PackedScene
@export var x_junction: PackedScene

func visualize(maze: Maze):
	for i in range(maze.length):
		var instance = get_cell_instance(i % 16).instantiate() as MazeCellObject
		instance.rotation = MazeFlags.rotation(i % 16)
		instance.position = maze.index_to_world_position(i)
		add_child(instance)

func get_cell_instance(i: int) -> PackedScene:
	if MazeFlags.is_dead_end(i):
		return dead_end
	elif MazeFlags.is_straight(i):
		return straight
	elif MazeFlags.is_corner(i):
		return corner
	elif MazeFlags.is_t_junction(i):
		return t_junction
	else:
		return x_junction
