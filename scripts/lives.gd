extends Node2D

var lives = 6

signal allLivesLost

func loseLife():
	if lives > 0:
		lives -= 1
		$sprite.frame = lives
	else:
		emit_signal("allLivesLost")
