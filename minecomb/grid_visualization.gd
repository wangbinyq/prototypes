class_name GridVisualization
extends MultiMeshInstance3D

const BLOCK_ROWS_PER_CELL = 7
const BLOCK_COLUMNS_PER_CELL = 5
const BLOCKS_PER_CELL = BLOCK_ROWS_PER_CELL * BLOCK_COLUMNS_PER_CELL

const BITMAPS = [
	0b00000_01110_01010_01010_01010_01110_00000, # 0
	0b00000_00100_00110_00100_00100_01110_00000, # 1
	0b00000_01110_01000_01110_00010_01110_00000, # 2
	0b00000_01110_01000_01110_01000_01110_00000, # 3
	0b00000_01010_01010_01110_01000_01000_00000, # 4
	0b00000_01110_00010_01110_01000_01110_00000, # 5
	0b00000_01110_00010_01110_01010_01110_00000, # 6
	0b00000_10001_01010_00100_01010_10001_00000, # mine
	0b00000_00000_00100_01110_00100_00000_00000, # marked sure
	0b11111_11111_11011_10001_11011_11111_11111, # marked mistaken
	0b00000_01110_01010_01000_00100_00000_00100, # marked unsure
	0b00000_00000_00000_00000_00000_00000_00000 # hidden
]

const COLORATIONS = [
	1.00 * Color(1, 1, 1), # 0
	1.00 * Color(0, 0, 1), # 1
	2.00 * Color(0, 1, 1), # 2
	5.00 * Color(0, 1, 0), # 3
	10.0 * Color(1, 1, 0), # 4
	20.0 * Color(1, 0, 0), # 5
	20.0 * Color(1, 0, 1), # 6

	30.0 * Color(1, 0, 1), # mine
	1.00 * Color(1, 0, 0), # marked sure
	50.0 * Color(1, 0, 1), # marked mistaken
	0.25 * Color(1, 1, 1), # marked unsure
	0.00 * Color(0, 0, 0) # hidden
]

var grid: Grid
var columns: int
var rows: int

func _init(g: Grid, material: Material, mesh: Mesh):
	grid = g
	columns = grid.columns
	rows = grid.rows
	multimesh = MultiMesh.new()
	multimesh.use_colors = true
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.mesh = mesh
	multimesh.mesh.surface_set_material(0, material)
	multimesh.instance_count = grid.cell_count * BLOCKS_PER_CELL
	update()


func get_block_position(i: int):
	var r = i / BLOCK_COLUMNS_PER_CELL
	var c = i - r * BLOCK_COLUMNS_PER_CELL
	return Vector3(c, 0, -r)

func get_cell_position(index: int) -> Vector3:
	var row_column = grid.get_row_column(index)
	var r = row_column[0]
	var c = row_column[1]
	return Vector3(
		c - (columns - 1) * 0.5,
		0,
		- (r - (rows - 1) * 0.5 - (c & 1) * 0.5 + 0.25)
	) * Vector3(
		BLOCK_COLUMNS_PER_CELL + 1,
		0,
		(BLOCK_ROWS_PER_CELL + 1),
	) - Vector3(
		BLOCK_COLUMNS_PER_CELL / 2.0,
		0,
		- BLOCK_ROWS_PER_CELL / 2.0,
	)

func update():
	var t = Transform3D.IDENTITY
	for i in range(grid.cell_count):
		var cell_pos = get_cell_position(i)
		var block_offset = i * BLOCKS_PER_CELL
		var bitmap = BITMAPS[i % BITMAPS.size()]
		var coloration = COLORATIONS[i % COLORATIONS.size()]
		for bi in range(BLOCKS_PER_CELL):
			var altered = bitmap & (1 << bi) != 0
			var pos = cell_pos + get_block_position(bi)
			pos.y = 0.5 if altered else 0.0
			t.origin = pos
			multimesh.set_instance_transform(block_offset + bi, t)
			multimesh.set_instance_color(block_offset + bi, Color.WHITE * (coloration if altered else 0.5))
