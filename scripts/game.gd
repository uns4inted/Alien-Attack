extends Node2D

@export var lives = 3
@export var score_for_kill = 100
@export var damage_penalty = 500

@export var game_over_screen: PackedScene

var score = 0

@onready var player = $Player
@onready var hud = $UI/HUD
@onready var timer = $Timer

var time = 20 # seconds from start


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
	
## TODO: add bonus points for special enemies
func _on_special_enemy_died():
	score += (score_for_kill * 3)
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


func _on_enemy_spawner_special_enemy_spawned(path_enemy):
	add_child(path_enemy)
	path_enemy.spawn_enemy()
	path_enemy.enemy.connect("died", _on_special_enemy_died)


func _on_timer_timeout():
	time += 1
	update_difficulty()

func update_difficulty():
	## difficulty params:
	## -- Easy ( less then 30 seconds ):
	## default spawn time
	## default enemy speed
	## -- Medium ( 30 - 60 seconds )
	## spawn time is decreased - n * 0.65
	## special spawn time is decreased - n * 0.65
	## speed is increased - n * 1.5
	## special speed is increased - n * 2
	## -- Hard ( 60+ seconds )
	## spawn time is decreasing each 10 seconds by n * 0.75 until 0.25 seconds
	## speed is increasing each 10 seconds by 1.2 up to 750
	
	## -- Medium --
	var current_enemy_spawn_time = $EnemySpawner.spawn_timer.wait_time
	var current_special_enemy_spawn_time = $EnemySpawner.special_enemy_spawn_timer.wait_time
	var current_enemy_speed = $EnemySpawner.enemy_speed
	var current_special_enemy_speed = $EnemySpawner.special_enemy_speed
	
	if (time == 30):
		$EnemySpawner.spawn_timer.wait_time = current_enemy_spawn_time * 0.65
		$EnemySpawner.special_enemy_spawn_timer.wait_time = current_special_enemy_spawn_time * 0.5
		$EnemySpawner.enemy_speed = current_enemy_speed * 1.5
		$EnemySpawner.special_enemy_speed = current_special_enemy_speed * 2
	## -- Hard --
	print (str(time))
	if (time > 30 && (time % 10 == 0)):
		if (current_enemy_spawn_time >= 0.25):
			$EnemySpawner.spawn_timer.wait_time = current_enemy_spawn_time * 0.75
		if (current_enemy_speed <= 750):
			$EnemySpawner.enemy_speed = current_enemy_speed * 1.2
			
	# for testing
	#print("Current enemy spawn time: " + str(current_enemy_spawn_time))
	#print("Current special enemy spawn time: " + str(current_special_enemy_spawn_time))
	#print("Current enemy speed: " + str(current_enemy_speed))
	#print("Current special enemy speed: " + str(current_special_enemy_speed))
