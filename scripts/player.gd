extends CharacterBody2D

signal took_damage

@export var speed = 300
@export var fire_cd_time = 0.35 ## in seconds
@export var rocket_scene: PackedScene # projectile rockets of player

@onready var rocket_container = $RocketContainer
@onready var on_being_hit_sound = $OnBeingHitSFX

var fire_on_cd = false

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		shoot()

func _physics_process(delta):
	
	velocity = Vector2(0, 0) # reset velocity each frame

	# Player controls
	if Input.is_action_pressed("move_up"):
		velocity.y = -speed
	if Input.is_action_pressed("move_down"):
		velocity.y = speed
	if Input.is_action_pressed("move_right"):
		velocity.x = speed
	if Input.is_action_pressed("move_left"):
		velocity.x = -speed
	move_and_slide()
	
	# Clamp player position inside game scene
	var screen_size = get_viewport_rect().size
	global_position = global_position.clamp(Vector2(10,10), Vector2(screen_size.x - 10, screen_size.y -10))
		


func shoot():
	if !fire_on_cd:
		var rocket = rocket_scene.instantiate()
		rocket_container.add_child(rocket)
		rocket.global_position = global_position
		rocket.global_position.x += 60
		
		fire_on_cd = true
		await get_tree().create_timer(fire_cd_time).timeout
		fire_on_cd = false

func take_damage():
	emit_signal("took_damage")
	on_being_hit_sound.play()
		
func die():
	hide()
	await on_being_hit_sound.finished
	queue_free()
