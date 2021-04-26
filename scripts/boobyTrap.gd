extends Node2D

class_name boobyTrap

export var trigger : String
export var type : String

export var rate : int = 10
export var stage = 1

var readyToFire = true
var currentStage = 1

func _set_sprite():
	$sprite.animation = type
	$letterBel.text = trigger

func _set_rate():
	$loadingTimer.wait_time = rate

func _attack():
	pass

func _input(event):
	
	if event.is_action_pressed(trigger) and readyToFire and currentStage == stage:
		_attack()
		$loadingTimer.start()
		readyToFire = false

func setLoadingSprite():
	$loadingSprite.frame = int(((rate - $loadingTimer.time_left) / rate) * 9)

func _on_loadingTimer_timeout():
	readyToFire = true

func _process(delta):
	setLoadingSprite()
