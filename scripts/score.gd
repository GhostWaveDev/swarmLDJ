extends Node2D

var score = 0

func _ready():
	updateText()

func updateText():
	$text.bbcode_text = "Score : " + str(score)

func addScore(number):
	score += number
	updateText()
