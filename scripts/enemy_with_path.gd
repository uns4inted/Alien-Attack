extends Node2D

@export var enemy_scene: PackedScene

@onready var rnd = RandomNumberGenerator.new()
var selected_path
var pathfollow

func _ready():
	set_random_path()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pathfollow.progress_ratio -= 0.1 * delta

func set_random_path():
	selected_path = get_tree().get_nodes_in_group("EnemyPath").pick_random()
	
	pathfollow = PathFollow2D.new()
	selected_path.add_child(pathfollow)
	pathfollow.loop = false
	pathfollow.rotates = false
	pathfollow.progress_ratio = 1
	
	var enemy_instance = enemy_scene.instantiate()
	enemy_instance.speed = 0
	pathfollow.add_child(enemy_instance)
