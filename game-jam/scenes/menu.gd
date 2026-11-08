extends Control
@onready var jogar: Button = $Button


func _ready() -> void:
	jogar.pressed.connect(iniciar_jogo)

func iniciar_jogo():
	get_tree().change_scene_to_file("res://scenes/world.tscn")
