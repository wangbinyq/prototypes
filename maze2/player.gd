class_name MazePlayer
extends CharacterBody3D

# 基本参数
@export var speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.002
@export var acceleration: float = 10.0
@export var deceleration: float = 15.0

# 重力常量
const GRAVITY: float = 9.8

# 引用子节点
@onready var camera: Camera3D = $Camera3D
@onready var head: Node3D = $Head # 可选：添加一个头部节点用于摄像机位置

# 私有变量
var _mouse_input: bool = true

func _ready() -> void:
	# 隐藏并锁定鼠标
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	# 处理鼠标移动
	if event is InputEventMouseMotion and _mouse_input:
		# 水平旋转角色
		rotate_y(-event.relative.x * mouse_sensitivity)
		
		# 垂直旋转摄像机
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		# 限制摄像机俯仰角度（约±85度）
		camera.rotation.x = clamp(camera.rotation.x, -1.48, 1.48)

func _unhandled_input(event: InputEvent) -> void:
	# 切换鼠标模式
	if event.is_action_pressed("escape"):
		toggle_mouse_mode()

func toggle_mouse_mode() -> void:
	_mouse_input = not _mouse_input
	if _mouse_input:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_jump()
	handle_movement(delta)

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

func handle_jump() -> void:
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity

func handle_movement(delta: float) -> void:
	# 获取输入
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	# 计算目标方向（忽略Y轴）
	var target_velocity: Vector3 = Vector3.ZERO
	if input_dir != Vector2.ZERO:
		# 使用摄像机方向进行移动
		var forward: Vector3 = camera.global_transform.basis.z.normalized()
		var right: Vector3 = camera.global_transform.basis.x.normalized()
		
		# 只在XZ平面移动
		forward.y = 0
		right.y = 0
		
		target_velocity = (forward * -input_dir.y + right * input_dir.x).normalized() * speed
		print(target_velocity)
	
	# 平滑插值速度
	var h_velocity: Vector2 = Vector2(velocity.x, velocity.z)
	var target_h_velocity: Vector2 = Vector2(target_velocity.x, target_velocity.z)
	
	if target_h_velocity.length() > 0:
		h_velocity = h_velocity.move_toward(target_h_velocity, acceleration * delta)
	else:
		h_velocity = h_velocity.move_toward(Vector2.ZERO, deceleration * delta)
	
	velocity.x = h_velocity.x
	velocity.z = h_velocity.y
