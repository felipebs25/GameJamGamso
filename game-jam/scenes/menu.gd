extends Control
@onready var jogar: Button = $Button
@onready var iniciar: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	jogar.pressed.connect(iniciar_jogo)

func iniciar_jogo():
	iniciar.play()
	await iniciar.finished
	get_tree().change_scene_to_file("res://scenes/inicio.tscn")
