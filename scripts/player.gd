extends CharacterBody2D


var speed = 300

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
	#global_position.x = clamp(global_position.x, 10, screen_size.x - 10)
	#global_position.y = clamp(global_position.y, 10, screen_size.y - 10)
	global_position = global_position.clamp(Vector2(10,10), Vector2(screen_size.x - 10, screen_size.y -10))
		
