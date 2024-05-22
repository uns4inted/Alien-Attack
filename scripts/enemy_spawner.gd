extends Node2D

@export var enemy_scene: PackedScene

@onready var spawn_positions = $SpawnPositions.get_children() # array of spawn points

func _on_timer_timeout():
	spawn_enemy()

func spawn_enemy():
	var random_spawn_position = spawn_positions.pick_random()
	
	var enemy = enemy_scene.instantiate()
	enemy.global_position = random_spawn_position.global_position
	add_child(enemy)
