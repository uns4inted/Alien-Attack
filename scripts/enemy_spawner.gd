extends Node2D

signal enemy_spawned(enemy_instance)

@export var enemy_scene: PackedScene
@export var spawn_time_seconds = 2

@onready var spawn_positions = $SpawnPositions.get_children() # array of spawn points
@onready var spawn_timer = $Timer

func _ready():
	spawn_timer.wait_time = spawn_time_seconds

func _on_timer_timeout():
	spawn_enemy()

func spawn_enemy():
	var random_spawn_position = spawn_positions.pick_random()
	
	var enemy = enemy_scene.instantiate()
	enemy.global_position = random_spawn_position.global_position
	emit_signal("enemy_spawned", enemy)

func stop_spawner():
	$Timer.stop()
