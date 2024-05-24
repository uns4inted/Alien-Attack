extends Node2D

@onready var rnd = RandomNumberGenerator.new()
@onready var enemy = $Enemy

var selected_path
var pathfollow
var speed = 0.1

func _ready():
	#spawn_enemy() # uncomment to test
	pass

func _process(delta):
	# check if pathfollow is exist to prevent error
	if not is_instance_valid(pathfollow):  
		return

	# move enemy using path
	if pathfollow.progress_ratio <= 0:
		queue_free()
	else:
		pathfollow.progress_ratio -= speed * delta

func set_random_path():
	selected_path = get_tree().get_nodes_in_group("EnemyPath").pick_random()

	# create pathfollow and add it as a child to selected path
	pathfollow = PathFollow2D.new()
	selected_path.add_child(pathfollow)
	pathfollow.loop = false
	pathfollow.rotates = false
	pathfollow.progress_ratio = 1

func spawn_enemy(): ## select random path and spawn an enemy on it
	set_random_path()
	enemy.reparent(pathfollow)
	enemy.global_position = pathfollow.global_position
	enemy.speed = 0
	enemy.get_node("Sprite2D").texture = load("res://assets/textures/enemy_ship_2.png")
