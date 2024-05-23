extends Node2D

@export var lives = 3
@export var score_for_kill = 100
@export var damage_penalty = 500

@export var game_over_screen: PackedScene

var score = 0

@onready var player = $Player
@onready var hud = $UI/HUD

func _ready():
	update_score_label()
	update_lives_label()

func _on_death_zone_area_entered(area):
	area.despawn()

func _on_player_took_damage():
	# penalty for being damaged
	if (score >= damage_penalty):
		score -= (damage_penalty + score_for_kill) # also remove score for kill
	elif (score < damage_penalty):
		score = -score_for_kill # set score to 0 + remove score for kill
	update_score_label()
	
	# live reduce and death
	lives -= 1
	update_lives_label()
	if (lives < 1):
		player.die()
		game_over()


func _on_enemy_spawner_enemy_spawned(enemy_instance):
	enemy_instance.connect("died", _on_enemy_died)	
	add_child(enemy_instance)

func _on_enemy_died():
	score += score_for_kill
	update_score_label()

func update_score_label():
		hud.set_score_label(score)

func update_lives_label():
	hud.set_lives_label(lives)

func game_over():
	await get_tree().create_timer(1.5).timeout
	
	var game_over_screen_instance = game_over_screen.instantiate()
	game_over_screen_instance.set_score_label(score)
	$UI.add_child(game_over_screen_instance)
	
	$UI/HUD.hide()
	$EnemySpawner.stop_spawner()
