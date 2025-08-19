extends Node3D

@export var mines_text: Label3D
@export var fps_text: Label
@export_range(1, 100) var rows := 8
@export_range(1, 100) var columns := 21
@export var mesh: Mesh
@export var material: Material


var grid_visualization: GridVisualization
var grid: Grid
var camera: Camera3D

func _ready() -> void:
	var vp = get_viewport()
	vp.msaa_3d = Viewport.MSAA_8X
	camera = vp.get_camera_3d()

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

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var pos = event.position
			var origin = camera.project_ray_origin(pos)
			var direction = camera.project_ray_normal(pos)
			var cell_index = grid_visualization.try_get_hit_cell_index(origin, direction)
			if cell_index > -1:
				grid[str(cell_index)] = CellState.MARKED_SURE
				grid_visualization.update()
