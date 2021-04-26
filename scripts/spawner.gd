extends Node2D

export var spawn_coor : Vector2 = Vector2.ZERO
export var time : Vector2 = Vector2(1, 10)

var uhOh = 10

var active = false

var playerScene = preload("res://scenes/player.tscn")

func _ready():
	$timer.wait_time = 2

func reset():
	uhOh = 10
	time = Vector2(1, 10)

func _on_timer_timeout():
	if active:
		var new_player = playerScene.instance()
		
		get_parent().add_child(new_player)
		
		new_player.global_position = spawn_coor
		
		$timer.wait_time = rand_range(time[0], time[1])
		
		uhOh -= 1
		
		if uhOh == 0 and time[1] > 2:
			time[1] -= 1
			uhOh = 10
		
	$timer.start()
