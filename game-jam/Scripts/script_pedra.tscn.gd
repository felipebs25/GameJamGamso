extends CharacterBody2D

const SPEED = 300.0
var direction: Vector2

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(direction * SPEED * delta)
	
	if collision:
		direction = Vector2.ZERO
		set_physics_process(false)
