extends Node

signal wave_started(wave_number: int)
signal wave_completed(wave_number: int)

var enemy_scene: PackedScene = preload("res://scenes/enemies/enemy.tscn")

var current_wave: int = 0
var enemies_remaining: int = 0
var spawn_interval: float = 4
var _spawn_timer: float = 0.0
var _enemies_to_spawn: Array = []
var _is_spawning: bool = false
var _grid: Node
var _level: Node
var endless_mode: bool = false

func _ready():
	wave_completed.connect(_on_wave_completed)

func _on_wave_completed(wave_number: int) -> void:
	if endless_mode:
		await get_tree().create_timer(3.0).timeout
		start_wave(generate_wave(3 + wave_number * 2))

func initialize(grid: Node, level: Node) -> void:
	_grid = grid
	_level = level

func _process(delta):
	if _is_spawning:
		if _enemies_to_spawn.size() > 0:
			_spawn_timer += delta
			if _spawn_timer >= spawn_interval:
				_spawn_timer = 0.0
				_spawn_next_enemy()
		else:
			_is_spawning = false

func start_wave(wave_data: Array) -> void:
	current_wave += 1
	_enemies_to_spawn = wave_data.duplicate()
	enemies_remaining = _enemies_to_spawn.size()
	_is_spawning = true
	emit_signal("wave_started", current_wave)

func _spawn_next_enemy() -> void:
	if _enemies_to_spawn.size() == 0:
		_is_spawning = false
		return
	var spawn_data = _enemies_to_spawn.pop_front()
	spawn_enemy(spawn_data.lane)

func spawn_enemy(lane: int) -> void:
	var enemy = enemy_scene.instantiate()
	enemy.lane = lane
	enemy.grid_ref = _grid
	enemy.position = Vector2(
		1152 + 45,
		_grid.grid_origin.y + (lane * _grid.CELL_SIZE) + (_grid.CELL_SIZE / 2)
	)
	enemy.get_node("ProgressBar") #<LK>: Temporary. This needs to be wired up properly
	_level.add_child(enemy)

func on_enemy_died() -> void:
	enemies_remaining -= 1
	if enemies_remaining <= 0 and not _is_spawning:
		emit_signal("wave_completed", current_wave)

func generate_wave(enemy_count: int) -> Array:
	var wave_data: Array = []
	for i in enemy_count:
		var random_lane = randi() % _grid.ROWS
		wave_data.append({"lane": random_lane})
	return wave_data
