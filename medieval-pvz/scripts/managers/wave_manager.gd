extends Node

signal wave_started(wave_number: int)
signal wave_completed(wave_number: int)

var enemy_scene: PackedScene = preload("res://scenes/enemies/enemy.tscn")

var current_wave: int = 0
var enemies_remaining: int = 0
var spawn_interval: float = 1.5
var _spawn_timer: float = 0.0
var _enemies_to_spawn: Array = []
var _is_spawning: bool = false
var _grid: Node
var _level: Node

func initialize(grid: Node, level: Node) -> void:
	_grid = grid
	_level = level

func _process(delta):
	if _is_spawning and _enemies_to_spawn.size() > 0:
		_spawn_timer += delta
		if _spawn_timer >= spawn_interval:
			_spawn_timer = 0.0
			_spawn_next_enemy()

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
