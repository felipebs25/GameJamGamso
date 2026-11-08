extends CharacterBody2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var magneto: AudioStreamPlayer = $"../pedra"

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2
var atraindo = false
var speed = 800

var player

func _physics_process(delta: float) -> void:
	if atraindo:
		magneto.play()
		direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		velocity.y += gravity * 0.7 *delta
		var collision = move_and_collide(velocity * delta)

		if collision:
			direction = Vector2.ZERO
			velocity = Vector2.ZERO
			set_physics_process(false)

func puxar(p):
	magneto.play()
	player = p
	atraindo = true
	collision_shape.disabled = true
	set_physics_process(true)
