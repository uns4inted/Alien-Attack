extends Control

@onready var score = $Score
@onready var lives = $LivesCount

func set_score_label(new_score):
	score.text = "SCORE: " + str(new_score)

func set_lives_label(new_lives):
	lives.text = str(new_lives)
