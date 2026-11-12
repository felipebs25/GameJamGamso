extends Node2D

const VINE_HOLD_TIME := 4
const DROP_STEPS := 20
const SHAKE_STEPS := 2
const DROP_STEP_DELAY := 0.1
const VINE_RESPAWN_TIME := 2.0   # segundos até a vinha voltar
const VINE_START_POS := Vector2i(0, 4)

@onready var vine_sound: AudioStreamPlayer = $vine
@onready var tilemap: TileMapLayer = $TileMapLayer
@onready var player: CharacterBody2D = $"../Player/CharacterBody2D"
var stone_scene = preload("res://scenes/stone.tscn")

var vine_timer := 0.0
var current_vine_id = null
var is_dropping := false
var current_vine_cell := Vector2i.ZERO

func _process(delta: float) -> void:
	var chance = randi_range(1, 500000 * delta)
	if chance == 1:
		drop_stone()
	var tile_pos: Vector2i = tilemap.local_to_map(tilemap.to_local(player.global_position))
	var tile_data: TileData = tilemap.get_cell_tile_data(tile_pos)
	var on_vine: bool = tile_data != null and tile_data.get_custom_data("is_vine") == true

	if not on_vine:
		player.is_using_vine = false
		player.can_use_vine = true
		_reset_vine_timer()
		return

	current_vine_cell = tile_pos

	if player.can_use_vine:
		player.is_using_vine = true

	if player.is_using_vine:
		if not vine_sound.playing:
			vine_sound.play()

	if not player.is_using_vine or is_dropping:
		_reset_vine_timer()
		return

	var vine_id = tile_data.get_custom_data("vine_id")
	if vine_id != current_vine_id:
		current_vine_id = vine_id
		vine_timer = 0.0

	vine_timer += delta
	if vine_timer >= VINE_HOLD_TIME:
		drop_vine()

func _reset_vine_timer() -> void:
	vine_timer = 0.0
	current_vine_id = null

func drop_vine() -> void:
	if is_dropping:
		return

	var start_pos := current_vine_cell
	var source_id := tilemap.get_cell_source_id(start_pos)
	if source_id == -1:
		return

	is_dropping = true
	var atlas_coords := tilemap.get_cell_atlas_coords(start_pos)
	var alternative := tilemap.get_cell_alternative_tile(start_pos)

	# --- Guarda o estado original da vinha (todas as células que serão afetadas) ---
	var saved_cells: Array = []
	for i in range(DROP_STEPS + 1):
		var pos := start_pos + Vector2i(0, i)
		var src := tilemap.get_cell_source_id(pos)
		if src != -1:
			saved_cells.append({
				"pos": pos,
				"source": src,
				"atlas": tilemap.get_cell_atlas_coords(pos),
				"alt": tilemap.get_cell_alternative_tile(pos),
			})

	player.is_using_vine = false
	player.can_use_vine = false

	for i in range(DROP_STEPS):
		var from_pos := start_pos + Vector2i(0, i)
		var to_pos := start_pos + Vector2i(0, i + 1)
		tilemap.erase_cell(from_pos)
		tilemap.set_cell(to_pos, source_id, atlas_coords, alternative)
		await get_tree().create_timer(DROP_STEP_DELAY).timeout

	tilemap.erase_cell(start_pos + Vector2i(0, DROP_STEPS))

	_reset_vine_timer()
	is_dropping = false

	# --- Espera e regenera ---
	await get_tree().create_timer(VINE_RESPAWN_TIME).timeout
	_restore_vine(saved_cells)

func _restore_vine(saved_cells: Array) -> void:
	for cell in saved_cells:
		tilemap.set_cell(cell["pos"], cell["source"], cell["atlas"], cell["alt"])

func drop_stone():
	var new_stone = stone_scene.instantiate()
	add_child(new_stone)
	new_stone.define_position(player)
