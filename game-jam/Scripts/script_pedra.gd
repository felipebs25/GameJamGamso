extends Node

@onready var line_2d: Line2D = $Line2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var projectile_collision_mask = 1

const Pedra = preload("uid://dm20hpg7ouw1e")

@onready var player = $"../Player/CharacterBody2D"
@onready var map: Node2D = $"../Map"
var carregar = 0
var maxP = false
var Atração = false
var pedraAtual
var d = false
var cd = false
func _process(delta: float) -> void:
	if Atração:
		if Input.is_action_pressed("M1"):
			atrair()
		if Input.is_action_pressed("M2"):
			puxarPedra()
	else:
		trajetoria()
		if Input.is_action_pressed("M1"):
			if carregar >= 100:
				maxP = true
			if not maxP:
				carregar += 80 * delta
		else:
			line_2d.clear_points()

func _input(event):
	if Input.is_action_just_released("M1") and not Atração:
		jogarPedra(event, carregar)
		carregar = 0
		maxP = false
		line_2d.clear_points()
		Atração = true
	elif Input.is_action_just_released("M1") and Atração:
		player.atraindo(0, false)
		await get_tree().create_timer(1).timeout
		cd = false

func atrair():
	if not is_instance_valid(pedraAtual):
		Atração = false
		return
	cd = true
	var direc = (pedraAtual.global_position - player.global_position).normalized()
	if pedraAtual.global_position.distance_to(player.global_position) <= 200:
		player.atraindo(direc, true)

func trajetoria():
	line_2d.clear_points()
	var pos = player.global_position
	var Ldirection = (player.get_global_mouse_position() - pos).normalized()
	var Lspeed = carregar * 10.0
	var vel = Ldirection * Lspeed
	var step = 1.0 / 60.0
	for i in range(120):
		vel.y += gravity * 0.7 * step
		var next_pos = pos + vel * step
		var query = PhysicsRayQueryParameters2D.create(
			pos,
			next_pos,
			projectile_collision_mask,
			[player.get_rid()]
		)
		var collision = player.get_world_2d().direct_space_state.intersect_ray(query)
		if collision:
			line_2d.add_point(map.to_local(collision.position))
			break
		line_2d.add_point(map.to_local(next_pos))
		pos = next_pos

func jogarPedra(event, valor):

	var pedra = Pedra.instantiate()
	map.add_child(pedra)
	
	pedra.global_position = player.global_position
	var Pbody = pedra.get_node("CharacterBody2D")
	pedraAtual = Pbody
	Pbody.direction = (player.get_global_mouse_position() - pedra.global_position).normalized()
	var speed = float(valor) / 100 * 1000
	Pbody.velocity = Pbody.direction * speed
	

func puxarPedra():
	if not is_instance_valid(pedraAtual):
		Atração = false
		return
	if cd == true:
		return
	var direc = (pedraAtual.global_position - player.global_position).normalized()
	player.ativarDash(direc)
	pedraAtual.puxar(player)
	apagarPedra(pedraAtual)
	
	
func apagarPedra(Pbody):
	if d == false:
		d = true
		while true:
			if Pbody.global_position.distance_to(player.global_position) <= 90.0:
				pedraAtual.queue_free()
				pedraAtual = null
				Atração = false
				d = false
				break
			await get_tree().create_timer(0.1).timeout
	
