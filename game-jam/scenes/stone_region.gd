extends Node2D
@export var speed := 400.0
@onready var pedra: AudioStreamPlayer = $pedra


func _process(delta: float) -> void:
	var stones = get_tree().get_nodes_in_group("stones")
	
	for stone in stones:
		stone.global_position.y += speed * delta
		if stone.global_position.y > 3000:
			self.queue_free()
