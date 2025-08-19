extends Node3D

@export var mines_text: Label3D
@export var fps_text: Label
@export_range(1, 100) var rows := 8
@export_range(1, 100) var columns := 21
@export var mesh: Mesh
@export var material: Material

var grid_visualization: GridVisualization
var grid: Grid

func _ready() -> void:
	var vp = get_viewport()
	vp.msaa_3d = Viewport.MSAA_8X

func _enter_tree() -> void:
	grid = Grid.new(rows, columns)
	grid_visualization = GridVisualization.new(grid, material, mesh)
	add_child(grid_visualization)

func _exit_tree() -> void:
	grid._destroy()
	grid_visualization.queue_free()

func _process(_delta):
	if grid.rows != rows or grid.columns != columns:
		_exit_tree()
		_enter_tree()
	var fps = Engine.get_frames_per_second()
	fps_text.text = "FPS: " + str(fps)


func _on_button_pressed() -> void:
	_exit_tree()
	_enter_tree()
