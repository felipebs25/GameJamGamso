extends Node2D
class_name shake_camera

@onready var camera_2d: Camera2D = $Camera2D

@export var decay: float = 0.8
@export var max_offset: Vector2 = Vector2(100, 75)
@export var max_roll: float = 0.1
@export var follow_node: Node2D

var trauma: float = 0.0
var trauma_power: int = 2

func _ready() -> void:
	randomize()
	camera_2d.make_current()

func _process(delta: float) -> void:
	if follow_node:
		global_position = follow_node.global_position

	if trauma > 0.0:
		trauma = max(trauma - decay * delta, 0.0)
		shake()
	else:
		camera_2d.offset = Vector2.ZERO
		camera_2d.rotation = 0.0

func add_trauma(amount: float) -> void:
	trauma = min(trauma + amount, 1.0)

func shake() -> void:
	var amount = pow(trauma, trauma_power)
	camera_2d.rotation = max_roll * amount * randf_range(-1, 1)
	camera_2d.offset.x = max_offset.x * amount * randf_range(-1, 1)
	camera_2d.offset.y = max_offset.y * amount * randf_range(-1, 1)
