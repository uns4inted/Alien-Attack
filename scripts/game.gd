extends Node2D

@export var lives = 3
var score = 0

@onready var player = $Player

func _on_death_zone_area_entered(area):
	area.die()


func _on_player_took_damage():
	lives -= 1
	print("player hp: " + str(lives))
	if (lives < 1):
		print("player died")
		player.die()


func _on_enemy_spawner_enemy_spawned(enemy_instance):
	enemy_instance.connect("died", _on_enemy_died)	
	add_child(enemy_instance)

func _on_enemy_died():
	score += 100
	print("score: " + str(score))
