extends Node2D

@export var lives = 3
@export var score_for_kill = 100
@export var damage_penalty = 1000
var score = 0


@onready var player = $Player

func _on_death_zone_area_entered(area):
	area.despawn()


func _on_player_took_damage():
	# penalty for being damaged
	if (score >= damage_penalty):
		score -= (damage_penalty + score_for_kill) # also remove score for kill
	elif (score < damage_penalty):
		score = -score_for_kill # set score to 0 + remove score for kill
	
	# live reduce and death
	lives -= 1	
	if (lives < 1):
		print("player died")
		player.die()


func _on_enemy_spawner_enemy_spawned(enemy_instance):
	enemy_instance.connect("died", _on_enemy_died)	
	add_child(enemy_instance)

func _on_enemy_died():
	score += score_for_kill
	print("score: " + str(score))
