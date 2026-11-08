extends CharacterBody2D

const SPEED = 200.0
const SPEED_VINE = 100.0
const JUMP_VELOCITY = -350.0

@onready var camera_2d: Camera2D = $Camera2D


var is_using_vine: bool = false
var can_use_vine: bool = true


func _physics_process(delta: float) -> void:
	
	for i in range(get_slide_collision_count()):
		var collider := get_slide_collision(i).get_collider()
		if collider and collider.name == "Stone":
			camera_2d.add_trauma(0.3)

	var horizontal_direction := Input.get_axis("ui_left", "ui_right")
	var vertical_direction := Input.get_axis("ui_up", "ui_down")

	if is_using_vine:
		velocity.x = 0
		velocity.y = vertical_direction * SPEED_VINE
		if Input.is_action_just_pressed("ui_space"):
			is_using_vine = false
			can_use_vine = false
			pular()

	else:
		if not is_on_floor():
			gravidade(delta)

		if Input.is_action_just_pressed("ui_space") and is_on_floor():
			pular()

		if horizontal_direction:
			velocity.x = horizontal_direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func pular():
	velocity.y = JUMP_VELOCITY


func gravidade(delta):
	velocity += get_gravity() * delta
