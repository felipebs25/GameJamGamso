extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var dashing = false
var atrair = false
var força_ima = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if atrair:
		velocity += força_ima * 1200 * delta
		velocity -= get_gravity() * delta * 0.7
		velocity = velocity.limit_length(600)

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction and not atrair:
		velocity.x = direction * SPEED
	elif not dashing and not atrair:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func atraindo(direc, b):
		atrair = b
		força_ima = direc if b else Vector2.ZERO

func ativarDash(direc):
	dashing = true
	velocity = direc * 400
	await get_tree().create_timer(0.5).timeout
	dashing = false
