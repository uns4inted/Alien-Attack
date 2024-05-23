extends Control

func set_score_label(new_score):
	$Panel/Score.text = "SCORE: " + str(new_score)

func _on_button_pressed():
	get_tree().reload_current_scene()
