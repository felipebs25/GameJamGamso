extends Node2D
class_name Stone
@onready var stone: CharacterBody2D = $Stone
@export var speed := 400.0


func _process(delta: float) -> void:
	stone.global_position.y += speed * delta
	if stone.global_position.y > 3000:
		self.queue_free()


func define_position(player):
	var tamanho_tela_vertical = get_viewport().get_visible_rect().size.y
	var topo_da_tela = player.global_position.y - (tamanho_tela_vertical / 2.0)
	var margem_seguranca = 100.0
	var pos_y = topo_da_tela - margem_seguranca
	var tamanho_tela_horizontal = get_viewport().get_visible_rect().size.x
	var pos_x = randi_range(1, tamanho_tela_horizontal)
	stone.global_position = Vector2(pos_x, pos_y)
