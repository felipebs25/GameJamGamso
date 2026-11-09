extends CharacterBody2D

const SPEED = 200.0
const SPEED_VINE = 100.0
const JUMP_VELOCITY = -350.0

@onready var magneto: AudioStreamPlayer = $"../magneto"
@onready var camera_2d: Camera2D = $Camera2D
@onready var footstep: AudioStreamPlayer = $footstep


var is_using_vine: bool = false
var can_use_vine: bool = true
var dashing = false
var atrair = false
var força_ima = Vector2.ZERO

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
			velocity += get_gravity() * delta
		if atrair:
			velocity += força_ima * 500 * delta
			velocity -= get_gravity() * delta * 0.8
			velocity = velocity.limit_length(300)

		if Input.is_action_just_pressed("ui_space") and is_on_floor():
			pular()

		if horizontal_direction and not atrair and not dashing:
			velocity.x = horizontal_direction * SPEED
		elif not dashing and not atrair:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	if is_on_floor() and not is_using_vine and horizontal_direction != 0:
		if not footstep.playing:
			footstep.play()
	else:
		footstep.stop()
	move_and_slide()
	
func pular():
	velocity.y = JUMP_VELOCITY


func gravidade(delta):
	velocity += get_gravity() * delta

func atraindo(direc, b):
	magneto.play()
	atrair = b
	força_ima = direc if b else Vector2.ZERO

func ativarDash(direc):
	magneto.play()
	dashing = true
	if not is_on_floor():
		velocity = direc * 400
	await get_tree().create_timer(0.6).timeout
	dashing = false
