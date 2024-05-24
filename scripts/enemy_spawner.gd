extends Node2D

signal enemy_spawned(enemy_instance)
signal special_enemy_spawned(special_enemy)

@export var enemy_scene: PackedScene
@export var enemy_spawn_time = 2 ## in sceonds
@export var special_enemy_spawn_time = 3 ## in seconds

var enemies_with_path = preload("res://scenes/enemy_with_path.tscn")
@onready var spawn_positions = $SpawnPositions.get_children() # array of spawn points
@onready var spawn_timer = $Timer
@onready var special_enemy_spawn_timer = $TimerForSpecialEnemies

func _ready():
	spawn_timer.wait_time = enemy_spawn_time
	special_enemy_spawn_timer.wait_time = special_enemy_spawn_time

func _on_timer_timeout():
	spawn_enemy()

func spawn_enemy():
	var random_spawn_position = spawn_positions.pick_random()
	
	var enemy = enemy_scene.instantiate()
	enemy.global_position = random_spawn_position.global_position
	emit_signal("enemy_spawned", enemy)

func stop_spawner():
	$Timer.stop()
	$TimerForSpecialEnemies.stop()


func _on_timer_for_special_enemies_timeout():
	spawn_special_enemy()

func spawn_special_enemy():
	var special_enemy = enemies_with_path.instantiate()
	emit_signal("special_enemy_spawned", special_enemy)
