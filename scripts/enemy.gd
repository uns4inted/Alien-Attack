extends Area2D

signal died

@export var speed = 300

@onready var on_get_hit_sound = $OnGetHitSFX


func _physics_process(delta):
	global_position.x -= speed * delta

func die():
	emit_signal("died")
	on_get_hit_sound.play()
	hide()
	await on_get_hit_sound.finished
	queue_free()

func despawn():
	queue_free()

func _on_body_entered(body):
	body.take_damage()
	die()
