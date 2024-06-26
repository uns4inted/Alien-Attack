extends Area2D

@export var speed = 500

@onready var onscrean_notifier = $VisibleOnScreenNotifier2D
@onready var on_launch_sound = $LaunchSFX

func _ready():
	onscrean_notifier.connect("screen_exited", _on_screen_exited)
	on_launch_sound.play()

func _physics_process(delta):
	global_position.x += speed * delta

func _on_screen_exited():
	queue_free()


func _on_area_entered(area):
	queue_free()
	area.die()
