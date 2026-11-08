extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var dashing = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		if is_on_floor():
			velocity.x = direction * SPEED
	elif not dashing:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func ativarDash(direc):
	dashing = true
	velocity = direc * 700
	await get_tree().create_timer(0.6).timeout
	dashing = false
