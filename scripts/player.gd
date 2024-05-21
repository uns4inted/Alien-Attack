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
